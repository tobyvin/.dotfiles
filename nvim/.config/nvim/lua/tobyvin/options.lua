local M = {}

M.setup = function()
	vim.g.mapleader = " "
	vim.g.netrw_preview = 1
	vim.g.netrw_banner = 0
	vim.g.netrw_altv = "nospr"
	vim.g.netrw_winsize = -30
	vim.g.netrw_usetab = 1
	vim.g.netrw_altfile = 1

	vim.opt.termguicolors = true
	vim.opt.background = "dark"
	vim.opt.laststatus = 3
	vim.opt.undofile = true
	vim.opt.swapfile = false
	vim.opt.clipboard = vim.opt.clipboard + "unnamedplus"
	vim.opt.shortmess = vim.opt.shortmess + "c"
	vim.opt.wrap = false
	vim.opt.showmatch = true
	vim.opt.cursorline = true
	vim.opt.number = true
	vim.opt.relativenumber = true
	vim.opt.incsearch = true
	vim.opt.hlsearch = true
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.scrolloff = 10
	vim.opt.sidescrolloff = 2
	vim.opt.backspace = { "indent", "start", "eol" }
	vim.opt.mouse = "a"
	vim.opt.updatetime = 500
	vim.opt.timeoutlen = 1000
	vim.opt.textwidth = 120
	vim.opt.tabstop = 4
	vim.opt.softtabstop = 0
	vim.opt.shiftwidth = 0
	vim.opt.smarttab = true
	vim.opt.expandtab = true
	vim.opt.autoindent = true
	vim.opt.breakindent = true
	vim.opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
	vim.opt.linebreak = true
	vim.opt.shiftround = true
	vim.opt.splitbelow = true
	vim.opt.splitright = true
	vim.opt.laststatus = 2
	vim.opt.colorcolumn = "+0"
	vim.opt.signcolumn = "yes:1"
	vim.opt.hidden = true
	vim.opt.inccommand = "split"
	vim.opt.shell = "zsh"
	vim.opt.wildignore = vim.opt.wildignore + { "*.o", "*.rej", "*.so" }
	vim.opt.lazyredraw = true
	vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
	vim.opt.spelllang = "en_us"
	vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
	vim.opt.spelloptions = { "camel", "noplainbuffer" }
	vim.opt.listchars = {
		eol = "↵",
		tab = "»-",
		trail = "·",
		extends = "…",
		precedes = "…",
	}
	vim.opt.sessionoptions = {
		"blank",
		"buffers",
		"curdir",
		"folds",
		"help",
		"tabpages",
		"winsize",
		"winpos",
		"terminal",
	}
	vim.opt.formatoptions = vim.opt.formatoptions
		- "a" -- Auto formatting is BAD.
		- "t" -- Don't auto format my code. I got linters for that.
		+ "c" -- In general, I like it when comments respect textwidth
		+ "q" -- Allow formatting comments w/ gq
		- "o" -- O and o, don't continue comments
		+ "r" -- But do continue when pressing enter.
		+ "n" -- Indent past the formatlistpat, not underneath it.
		+ "j" -- Auto-remove comments if possible.
		- "2" -- I'm not in gradeschool anymore
end

return M
