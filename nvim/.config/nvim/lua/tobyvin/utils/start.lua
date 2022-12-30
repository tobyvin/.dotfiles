local header = {
	"                                                    ",
	" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
	" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
	" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
	" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
	" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
	" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
	"                                                    ",
}

local function should_skip()
	-- don't start when opening a file
	if vim.fn.argc() > 0 then
		return true
	end

	-- skip stdin
	if vim.fn.line2byte(vim.fn.line("$")) ~= -1 then
		return true
	end

	-- Handle nvim -M
	if not vim.o.modifiable then
		return true
	end

	for _, arg in pairs(vim.v.argv) do
		-- whitelisted arguments
		-- always open
		if arg == "--startuptime" then
			return false
		end

		-- blacklisted arguments
		-- always skip
		if
			arg == "-b"
			-- commands, typically used for scripting
			or arg == "-c"
			or vim.startswith(arg, "+")
			or arg == "-S"
		then
			return true
		end
	end

	-- base case: don't skip
	return false
end

local function pad_string(str, pad, count)
	for _ = 1, count do
		str = pad .. str
	end
	return str
end

if should_skip() then
	return
end

local buf = vim.api.nvim_create_buf(true, true)

local width = vim.api.nvim_win_get_width(0)
local pad_width = math.floor((width / 2) - (#header[1] / 2))

for i, _ in ipairs(header) do
	header[i] = pad_string(header[i], " ", pad_width)
end

vim.api.nvim_buf_set_lines(buf, 0, -1, false, header)

vim.bo[buf].modifiable = false
vim.bo[buf].buflisted = false

vim.api.nvim_set_current_buf(buf)

vim.opt_local.textwidth = 0
vim.opt_local.bufhidden = "wipe"
vim.opt_local.buflisted = false
vim.opt_local.matchpairs = ""
vim.opt_local.swapfile = false
vim.opt_local.buftype = "nofile"
vim.opt_local.filetype = "alpha"
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
