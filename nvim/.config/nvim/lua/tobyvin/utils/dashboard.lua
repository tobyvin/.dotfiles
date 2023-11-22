---@param lines string[]
---@return integer
local function max_len(lines)
	local max = 0
	for _, line in ipairs(lines) do
		max = math.max(max, vim.fn.strdisplaywidth(line))
	end
	return max
end

---@param lines string[]
---@return string[]
local function pad_horz(lines, width)
	local max_line_len = max_len(lines)
	local padded = {}
	for _, line in ipairs(lines) do
		local line_len = max_line_len
		local pad_len = math.floor((width / 2) - (line_len / 2))
		table.insert(padded, string.rep(" ", pad_len) .. line)
	end
	return padded
end

---@class Dashboard
---@field sections (string[] | fun():string[])[]
---@field rendered string[][]
---@field augroup integer?
---@field win integer?
---@field buf integer?
---@field setup function
local M = {
	rendered = {},
	sections = {
		function()
			if vim.fn.executable("fortune") ~= 1 then
				return {}
			end

			local cmd = vim.system({ "fortune", "-s" }, { text = true })
			if vim.fn.executable("cowsay") == 1 then
				cmd = vim.system({ "cowsay" }, { text = true, stdin = cmd:wait().stdout })
			end

			return vim.split(cmd:wait().stdout or "", "\n")
		end,
		{
			" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
		},
		function()
			if not pcall(require, "lazy") then
				return {}
			end

			local stats = require("lazy").stats()
			local lines = {
				string.format("startup: %s ms", stats.startuptime),
				string.format("plugins: %s (%s loaded)", stats.count, stats.loaded),
			}

			if require("lazy.status").has_updates() then
				table.insert(lines, string.format("updates: %s", require("lazy.status").updates()))
			end

			return lines
		end,
	},
}

function M.render(bufnr, index)
	bufnr = bufnr or 0

	local width = vim.api.nvim_win_get_width(0)
	local height = vim.api.nvim_win_get_height(0)

	local rendered = {}
	local dashboard = vim.b[bufnr].dashboard or {}

	local mid_height = 0
	for i, section in pairs(M.sections) do
		if dashboard[i] == nil or index == nil or index == i then
			if type(section) == "table" then
				dashboard[i] = pad_horz(section, width)
			elseif type(section) == "function" then
				dashboard[i] = pad_horz(section(), width)
			end
		end

		if i < (#M.sections / 2) then
			mid_height = mid_height + #dashboard[i]
		elseif i == math.ceil(#M.sections / 2) then
			mid_height = mid_height + math.ceil(#dashboard[i] / 2)
		end

		vim.list_extend(rendered, dashboard[i])
		table.insert(rendered, "")
	end

	if mid_height < math.ceil(height / 3) then
		for _ = 1, (math.ceil(height / 3) - mid_height) do
			table.insert(rendered, 1, "")
		end
	end

	vim.bo[bufnr].modifiable = true
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, rendered)
	vim.bo[bufnr].modifiable = false
	vim.b[bufnr].dashboard = dashboard
end

function M.initialize()
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_current_buf(bufnr)
	local winid = vim.api.nvim_get_current_win()

	vim.bo[bufnr].textwidth = 0
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].buflisted = false
	vim.bo[bufnr].matchpairs = ""
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].filetype = "dashboard"
	vim.bo[bufnr].synmaxcol = 0
	vim.wo[winid][0].wrap = false
	vim.wo[winid][0].colorcolumn = ""
	vim.wo[winid][0].foldlevel = 999
	vim.wo[winid][0].foldcolumn = "0"
	vim.wo[winid][0].cursorcolumn = false
	vim.wo[winid][0].cursorline = false
	vim.wo[winid][0].number = false
	vim.wo[winid][0].relativenumber = false
	vim.wo[winid][0].list = false
	vim.wo[winid][0].spell = false
	vim.wo[winid][0].signcolumn = "no"

	vim.b[bufnr].dashboard = {}
	vim.b[bufnr].dashboard.augroup = vim.api.nvim_create_augroup("dashboard", { clear = true })

	return bufnr
end

function M.next_fortune(bufnr)
	M.render(bufnr, 1)
end

function M.refresh_stats(bufnr)
	M.render(bufnr, 3)
end

function M.setup()
	local augroup = vim.api.nvim_create_augroup("dashboard", { clear = true })
	local bufnr = M.initialize()

	vim.api.nvim_create_autocmd("User", {
		group = augroup,
		pattern = { "LazyVimStarted", "LazyLoad", "LazyCheck" },
		callback = function()
			M.refresh_stats(bufnr)
		end,
		desc = "dashboard lazy stats",
	})

	vim.api.nvim_create_autocmd({ "BufHidden", "BufDelete", "BufLeave" }, {
		group = augroup,
		buffer = bufnr,
		callback = function()
			vim.api.nvim_del_augroup_by_id(augroup)
			return true
		end,
		desc = "clear dashboard autocmds",
	})

	M.render(bufnr)
	return bufnr
end

return M
