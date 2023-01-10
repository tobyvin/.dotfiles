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

local function max_len(lines)
	local max = 0
	for _, line in ipairs(lines) do
		max = math.max(max, vim.fn.strdisplaywidth(line))
	end
	return max
end

local overwrite_len = 0

local function buf_append_lines(buf, lines, left_align, overwrite)
	if type(lines) == "string" then
		lines = { lines }
	end

	local max_line_len = 0

	if left_align then
		max_line_len = max_len(lines)
	end

	local width = vim.api.nvim_win_get_width(0)
	for i, line in ipairs(lines) do
		local line_len = max_line_len
		if not left_align then
			line_len = vim.fn.strdisplaywidth(line)
		end

		local pad_len = math.floor((width / 2) - (line_len / 2))
		lines[i] = string.rep(" ", pad_len) .. line
	end

	local start = -1
	if overwrite then
		start = start - overwrite_len
		overwrite_len = #lines
	end

	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, start, -1, false, lines)
	vim.bo[buf].modifiable = false
end

if should_skip() then
	return
end

local buf = vim.api.nvim_create_buf(false, true)

vim.api.nvim_set_current_buf(buf)

vim.opt_local.textwidth = 0
vim.opt_local.bufhidden = "wipe"
vim.opt_local.buflisted = false
vim.opt_local.matchpairs = ""
vim.opt_local.swapfile = false
vim.opt_local.buftype = "nofile"
vim.opt_local.filetype = "start"
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

buf_append_lines(buf, header)

vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("dashboard", { clear = true }),
	pattern = { "Lazy*" },
	callback = function()
		local stats = require("lazy").stats()
		local lines = {
			string.format("startup: %s ms", stats.startuptime),
			string.format("plugins: %s (%s loaded)", stats.count, stats.loaded),
		}

		if require("lazy.status").has_updates() then
			table.insert(lines, string.format("updates: %s", require("lazy.status").updates()))
		end

		buf_append_lines(buf, lines, true, true)
	end,
	desc = "dashboard lazy stats",
})
