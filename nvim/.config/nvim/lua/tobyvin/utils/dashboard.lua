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

function M.next_fortune(bufnr)
	M.render(bufnr, 1)
end

function M.refresh_stats(bufnr)
	M.render(bufnr, 3)
end

function M.render(bufnr, index)
	bufnr = bufnr or 0

	local opts = vim.b[bufnr].dashboard_opts
	local width = vim.api.nvim_win_get_width(opts.winid)
	local height = vim.api.nvim_win_get_height(opts.winid)

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

function M.initialize(opts)
	local bufnr = vim.api.nvim_create_buf(false, true)

	if not opts.winid then
		if opts.float then
			opts.winid = vim.api.nvim_open_win(bufnr, opts.float_enter, opts.float_opts)
		else
			opts.winid = vim.api.nvim_get_current_win()
			vim.api.nvim_win_set_buf(opts.winid, bufnr)
		end
	end

	vim.bo[bufnr].textwidth = 0
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].buflisted = false
	vim.bo[bufnr].matchpairs = ""
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].filetype = "dashboard"
	vim.bo[bufnr].synmaxcol = 0

	vim.iter(opts.win_opts):each(function(k, v)
		vim.wo[opts.winid][0][k] = v
	end)

	vim.b[bufnr].dashboard_opts = opts

	return bufnr
end

function M.on_enter()
	if vim.fn.argc() == 0 then
		M.setup()
	end
	return true
end

function M.setup(opts)
	opts = vim.tbl_extend("keep", opts or {}, {
		float = false,
		float_enter = false,
		float_opts = {
			relative = "editor",
			width = 80,
			height = 50,
			col = (vim.o.columns - (opts and opts.width or 80)) / 2,
			row = (vim.o.lines - (opts and opts.height or 50)) / 2,
			style = "minimal",
		},
		win_opts = {
			wrap = false,
			colorcolumn = "",
			foldlevel = 999,
			foldcolumn = "0",
			cursorcolumn = false,
			cursorline = false,
			number = false,
			relativenumber = false,
			list = false,
			spell = false,
			signcolumn = "no",
		},
	})

	local bufnr = M.initialize(opts)

	local augroup = vim.api.nvim_create_augroup("dashboard", { clear = true })
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
