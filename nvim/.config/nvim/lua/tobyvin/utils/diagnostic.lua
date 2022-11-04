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

return M
