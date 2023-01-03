vim.g.mapleader = " "

vim.opt.autoindent = true
vim.opt.background = "dark"
vim.opt.backspace = { "indent", "start", "eol" }
vim.opt.breakindent = true
vim.opt.clipboard = vim.opt.clipboard + "unnamedplus"
vim.opt.colorcolumn = "+0"
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.incsearch = true
vim.opt.laststatus = 2
vim.opt.laststatus = 3
vim.opt.linebreak = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shell = "zsh"
vim.opt.shiftround = true
vim.opt.shiftwidth = 0
vim.opt.shortmess = vim.opt.shortmess + "c"
vim.opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
vim.opt.showmatch = true
vim.opt.sidescrolloff = 2
vim.opt.signcolumn = "yes:1"
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.softtabstop = 0
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
vim.opt.spelllang = "en_us"
vim.opt.spelloptions = { "camel", "noplainbuffer" }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.textwidth = 100
vim.opt.timeoutlen = 1000
vim.opt.undofile = true
vim.opt.updatetime = 500
vim.opt.wildignore = vim.opt.wildignore + { "*.o", "*.rej", "*.so" }
vim.opt.wrap = false
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
