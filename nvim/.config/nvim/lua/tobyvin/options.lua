vim.g.mapleader = " "
vim.g.maplocalleader = vim.g.mapleader
vim.g.tex_flavor = "latex"

vim.opt.autoindent = true
vim.opt.background = "dark"
vim.opt.backspace = { "indent", "start", "eol" }
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.colorcolumn = "+0"
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.conceallevel = 2
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.expandtab = true
vim.opt.formatoptions = "cqrnj"
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.linebreak = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.sessionoptions = { "buffers", "curdir", "folds", "help", "tabpages", "winsize", "winpos" }
vim.opt.shell = "zsh"
vim.opt.shiftround = true
vim.opt.shiftwidth = 0
vim.opt.showmode = false
vim.opt.shortmess:append("c")
vim.opt.showbreak = string.rep(" ", 3)
vim.opt.showmatch = true
vim.opt.sidescrolloff = 2
vim.opt.signcolumn = "yes:1"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 0
vim.opt.spelllang = "en_us"
vim.opt.spelloptions = { "camel", "noplainbuffer" }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.switchbuf = { "useopen", "split", "uselast" }
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.textwidth = 100
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.wildignore = { "*.o", "*.rej", "*.so" }
vim.opt.wildmode = "longest:full,full"
vim.opt.wrap = false
