---@type string[][]
local dashboard = {}

---@type table<string,integer>
local _index = {
	header = 1,
	lazy = 2,
	fortune = 3,
}

---@type string[]
local sections = setmetatable({}, {
	__index = function(_, k)
		return dashboard[_index[k]]
	end,

	__newindex = function(_, k, v)
		if _index[k] then
			dashboard[_index[k]] = v
		else
			table.insert(dashboard, v)
			_index[k] = #dashboard
		end
		vim.api.nvim_exec_autocmds("User", { pattern = "DashboardUpdate" })
	end,
})

local function max_len(lines)
	local max = 0
	for _, line in ipairs(lines) do
		max = math.max(max, vim.fn.strdisplaywidth(line))
	end
	return max
end

local function pad_lines(lines, win)
	local max_line_len = max_len(lines)
	local width = vim.api.nvim_win_get_width(win)
	local padded = {}
	for _, line in ipairs(lines) do
		local line_len = max_line_len
		local pad_len = math.floor((width / 2) - (line_len / 2))
		table.insert(padded, string.rep(" ", pad_len) .. line)
	end
	return padded
end

local function render(buf, win)
	local rendered = {}
	for _, lines in pairs(dashboard) do
		vim.list_extend(rendered, pad_lines(lines, win))
	end
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, rendered)
	vim.bo[buf].modifiable = false
end

-- if require("tobyvin.utils").normal_startup() then
-- 	return
-- end

local curr_buf = vim.api.nvim_get_current_buf()
local buf = vim.api.nvim_create_buf(false, true)
local win = vim.api.nvim_get_current_win()

vim.api.nvim_set_current_buf(buf)
vim.api.nvim_buf_delete(curr_buf, {})

vim.opt_local.textwidth = 0
vim.opt_local.bufhidden = "wipe"
vim.opt_local.buflisted = false
vim.opt_local.matchpairs = ""
vim.opt_local.swapfile = false
vim.opt_local.buftype = "nofile"
vim.opt_local.filetype = "dashboard"
vim.opt_local.synmaxcol = 0
vim.opt_local.wrap = false
vim.opt_local.colorcolumn = ""
vim.opt_local.foldlevel = 999
vim.opt_local.foldcolumn = "0"
vim.opt_local.cursorcolumn = false
vim.opt_local.cursorline = false
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.list = false
vim.opt_local.spell = false
vim.opt_local.signcolumn = "no"

local function with_spacer(lines, count)
	local spaced = lines
	while #spaced < count do
		table.insert(spaced, 1, "")
	end
	return spaced
end

local function fortune()
	local Job = require("plenary.job")
	local job = Job:new({ command = "fortune", args = { "-s" } })

	local ok, is_exe = pcall(vim.fn.executable, "cowsay")
	if ok and 1 == is_exe then
		job = Job:new({ command = "cowsay", writer = job })
	end

	return job:sync()
end

local augroup = vim.api.nvim_create_augroup("dashboard", { clear = true })

vim.api.nvim_create_autocmd("User", {
	group = augroup,
	pattern = { "DashboardUpdate" },
	callback = function()
		pcall(render, buf, win)
	end,
	desc = "render dashboard on updates",
})

vim.api.nvim_create_autocmd("BufHidden", {
	group = augroup,
	pattern = { "*" },
	callback = function(args)
		if args.buf == buf then
			vim.api.nvim_del_autocmd(augroup)
			return true
		end
	end,
	desc = "clear dashboard autocmds",
})

local ok, is_exe = pcall(vim.fn.executable, "fortune")
if ok and 1 == is_exe then
	sections.fortune = fortune()

	vim.keymap.set("n", "<C-n>", function()
		sections.fortune = fortune()
	end, { desc = "next cowsay", buffer = buf })
end

sections.header = with_spacer({
	"                                                    ",
	" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
	" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
	" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
	" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
	" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
	" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
	"                                                    ",
}, 15)

vim.api.nvim_create_autocmd("User", {
	group = augroup,
	pattern = { "Lazy*" },
	callback = function()
		local updates = nil
		if require("lazy.status").has_updates() then
			updates = string.format("updates: %s", require("lazy.status").updates())
		end

		local stats = require("lazy").stats()
		sections.lazy = {
			string.format("startup: %s ms", stats.startuptime),
			string.format("plugins: %s (%s loaded)", stats.count, stats.loaded),
			updates,
		}
	end,
	desc = "dashboard lazy stats",
})

print("setup dashboard")
