local M = {}

M.signs = {
	hint = { text = " ", texthl = "DiagnosticSignHint" },
	info = { text = " ", texthl = "DiagnosticSignInfo" },
	warn = { text = " ", texthl = "DiagnosticSignWarn" },
	error = { text = " ", texthl = "DiagnosticSignError" },
}

setmetatable(M.signs, {
	__index = function(t, k)
		if type(k) == "number" then
			return t[vim.diagnostic.severity[k]]
		end
		return t[k:lower():gsub("warning", "warn")]
	end,
})

---@param bufnr number?
---@return table
M.count = function(bufnr)
	local items = {}
	for i, level in ipairs(vim.diagnostic.severity) do
		items[level] = #vim.diagnostic.get(bufnr, { severity = i })
	end

	setmetatable(items, {
		__index = function(t, k)
			if type(k) == "number" then
				return t[vim.diagnostic.severity[k]]
			end
			return t[k:upper():gsub("WARNING", "WARN")]
		end,
	})

	return items
end

---@param bufnr number?
---@return string
M.indicator = function(bufnr)
	local diagnostic_count = M.count(bufnr)
	local tbl = {}
	for level, count in pairs(diagnostic_count) do
		if count > 0 then
			local color = "%#" .. M.signs[level].texthl .. "#"
			local indicator = color .. M.signs[level].text .. count
			table.insert(tbl, indicator)
		end
	end
	return table.concat(tbl, " ")
end

M.buf_count = function(bufnr)
	return M.count(vim.F.if_nil(bufnr, vim.fn.bufnr()))
end

M.buf_indicator = function(bufnr)
	return M.indicator(vim.F.if_nil(bufnr, vim.fn.bufnr()))
end

local function get_buffers(opts)
	local buffers = {}

	local diagnostics = vim.diagnostic.get(nil, opts)
	for _, diagnostic in ipairs(diagnostics) do
		local bufnr = diagnostic.bufnr --[[@as number]]
		if not vim.tbl_contains(buffers, bufnr) then
			table.insert(buffers, bufnr)
		end
	end

	return buffers
end

---@param opts table
---@param search_forward boolean Search forward
---@return number? Buffer number
local function next_buffer(opts, search_forward)
	local win_id = opts.win_id or vim.api.nvim_get_current_win()
	local bufnr = vim.api.nvim_win_get_buf(win_id)
	local buffers = get_buffers(opts)
	local sort_buffers, is_next

	if search_forward then
		sort_buffers = function(a, b)
			return a < b
		end
		is_next = function(a)
			return a > bufnr
		end
	else
		sort_buffers = function(a, b)
			return a > b
		end
		is_next = function(a)
			return a < bufnr
		end
	end

	table.sort(buffers, sort_buffers)

	for _, buffer in ipairs(buffers) do
		if is_next(buffer) then
			return buffer
		end
	end

	if opts.wrap then
		return buffers[1]
	end
end

---@param opts table?
---@param search_forward boolean Search forward
local function goto_diagnostic(opts, search_forward)
	opts = opts or {}
	opts.wrap = opts.wrap == nil or opts.wrap
	local win_id = opts.win_id or vim.api.nvim_get_current_win()

	local get_pos, goto_pos
	if search_forward then
		get_pos = vim.diagnostic.get_next_pos
		goto_pos = vim.diagnostic.goto_next
	else
		get_pos = vim.diagnostic.get_prev_pos
		goto_pos = vim.diagnostic.goto_prev
	end

	local pos_opts = vim.tbl_extend("force", opts, { wrap = false })
	local pos = get_pos(pos_opts)
	if not pos then
		local buffer = next_buffer(opts, true)
		if buffer then
			vim.api.nvim_win_set_buf(win_id, buffer)
			vim.api.nvim_win_set_cursor(win_id, { 1, 0 })
		end
	end

	return goto_pos(opts)
end

--- Move to the next diagnostic in the workspace.
---
---@param opts table?
function M.goto_next_workspace(opts)
	goto_diagnostic(opts, true)
end

--- Move to the prev diagnostic in the workspace.
---
---@param opts table?
function M.goto_prev_workspace(opts)
	goto_diagnostic(opts, false)
end

return M
