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
local function pad_vert(lines, height)
	local padded = lines
	for _ = 1, (height - #lines) / 3 do
		table.insert(padded, 1, "")
	end
	return padded
end

---@return string[], boolean?
local function fortune()
	if vim.fn.executable("fortune") ~= 1 then
		return {}
	end

	local Job = require("plenary.job")
	local job = Job:new({ command = "fortune", args = { "-s" } })

	if vim.fn.executable("cowsay") == 1 then
		job = Job:new({ command = "cowsay", writer = job })
	end

	return job:sync()
end

---@return string[]
local function lazy_stats()
	if not pcall(require, "lazy") then
		return {}
	end

	local updates = nil
	if require("lazy.status").has_updates() then
		updates = string.format("updates: %s", require("lazy.status").updates())
	end

	local stats = require("lazy").stats()

	return {
		string.format("startup: %s ms", stats.startuptime),
		string.format("plugins: %s (%s loaded)", stats.count, stats.loaded),
		updates,
	}
end

---@class Dashboard
---@field sections string[][]
---@field augroup integer?
---@field win integer?
---@field buf integer?
---@field setup function
local M = {
	sections = {
		fortune(),
		{
			" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
		},
		lazy_stats(),
	},
}

function M:render()
	local width = vim.api.nvim_win_get_width(self.win)
	local height = vim.api.nvim_win_get_height(self.win)

	local rendered = {}
	for _, section in pairs(self.sections) do
		vim.list_extend(rendered, pad_horz(section, width))
		table.insert(rendered, "")
	end

	rendered = pad_vert(rendered, height)

	vim.bo[self.buf].modifiable = true
	vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, rendered)
	vim.bo[self.buf].modifiable = false
end

function M:create_buf()
	self.buf = vim.api.nvim_create_buf(false, true)
	self.win = vim.api.nvim_get_current_win()
	vim.api.nvim_set_current_buf(self.buf)

	local opts = { scope = "local", win = self.win }

	vim.bo[self.buf].textwidth = 0
	vim.bo[self.buf].bufhidden = "wipe"
	vim.bo[self.buf].buflisted = false
	vim.bo[self.buf].matchpairs = ""
	vim.bo[self.buf].swapfile = false
	vim.bo[self.buf].buftype = "nofile"
	vim.bo[self.buf].filetype = "dashboard"
	vim.bo[self.buf].synmaxcol = 0
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
		M:create_buf()
	end

	vim.keymap.set("n", "<C-n>", function()
		M.sections[1] = fortune()
		M:render()
	end, { desc = "next cowsay", buffer = M.buf })

	vim.api.nvim_create_autocmd("User", {
		group = M.augroup,
		pattern = { "LazyVimStarted" },
		callback = function()
			M.sections[3] = lazy_stats()
			M:render()
		end,
		desc = "dashboard lazy stats",
	})

	M:render()
end

return M
