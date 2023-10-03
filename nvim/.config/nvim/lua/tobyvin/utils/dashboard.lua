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

---@param lines string[]
---@return string[]
local function pad_top(lines, height)
	if #lines < height then
		for _ = 1, (height - #lines) do
			table.insert(lines, 1, "")
		end
	end
	return lines
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

			local Job = require("plenary.job")
			local job = Job:new({ command = "fortune", args = { "-s" } })

			if vim.fn.executable("cowsay") == 1 then
				job = Job:new({ command = "cowsay", writer = job })
			end

			return pad_top(job:sync(), (vim.api.nvim_win_get_height(0) / 3) - 3)
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

function M.render(index)
	if M.buf == nil or not vim.api.nvim_buf_is_valid(M.buf) then
		M.create_buf()
	end

	local width = vim.api.nvim_win_get_width(M.win)
	local rendered = {}

	for i, section in pairs(M.sections) do
		if M.rendered[i] == nil or index == nil or index == i then
			if type(section) == "table" then
				M.rendered[i] = pad_horz(section, width)
			elseif type(section) == "function" then
				M.rendered[i] = pad_horz(section(), width)
			end
		end

		vim.list_extend(rendered, M.rendered[i])
		table.insert(rendered, "")
	end

	vim.bo[M.buf].modifiable = true
	vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, rendered)
	vim.bo[M.buf].modifiable = false
end

function M.create_buf()
	M.buf = vim.api.nvim_create_buf(false, true)
	M.win = vim.api.nvim_get_current_win()
	vim.api.nvim_set_current_buf(M.buf)

	vim.bo[M.buf].textwidth = 0
	vim.bo[M.buf].bufhidden = "wipe"
	vim.bo[M.buf].buflisted = false
	vim.bo[M.buf].matchpairs = ""
	vim.bo[M.buf].swapfile = false
	vim.bo[M.buf].buftype = "nofile"
	vim.bo[M.buf].filetype = "dashboard"
	vim.bo[M.buf].synmaxcol = 0

	local opts = { scope = "local", win = M.win }
	vim.api.nvim_set_option_value("wrap", false, opts)
	vim.api.nvim_set_option_value("colorcolumn", "", opts)
	vim.api.nvim_set_option_value("foldlevel", 999, opts)
	vim.api.nvim_set_option_value("foldcolumn", "0", opts)
	vim.api.nvim_set_option_value("cursorcolumn", false, opts)
	vim.api.nvim_set_option_value("cursorline", false, opts)
	vim.api.nvim_set_option_value("number", false, opts)
	vim.api.nvim_set_option_value("relativenumber", false, opts)
	vim.api.nvim_set_option_value("list", false, opts)
	vim.api.nvim_set_option_value("spell", false, opts)
	vim.api.nvim_set_option_value("signcolumn", "no", opts)

	M.augroup = vim.api.nvim_create_augroup("dashboard", { clear = true })
	vim.api.nvim_create_autocmd({ "BufHidden", "BufDelete", "BufLeave" }, {
		group = M.augroup,
		pattern = { "*" },
		callback = function(args)
			if args.buf == M.buf then
				vim.api.nvim_del_augroup_by_id(M.augroup)
				M.buf = nil
				M.win = nil
				M.augroup = nil
				return true
			end
		end,
		desc = "clear dashboard autocmds",
	})
end

function M.setup()
	if M.buf == nil or not vim.api.nvim_buf_is_valid(M.buf) then
		M.create_buf()
	end

	vim.keymap.set("n", "<C-n>", function()
		M.render(1)
	end, { desc = "next cowsay", buffer = M.buf })

	vim.api.nvim_create_autocmd("User", {
		group = M.augroup,
		pattern = { "LazyVimStarted", "LazyLoad", "LazyCheck" },
		callback = function()
			M.render(3)
		end,
		desc = "dashboard lazy stats",
	})

	M:render()
end

return M
