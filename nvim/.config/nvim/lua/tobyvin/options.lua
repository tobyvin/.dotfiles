vim.g.mapleader = " "
vim.g.maplocalleader = vim.g.mapleader

vim.opt.background = "dark"
vim.opt.breakindent = true
vim.opt.colorcolumn = "+1"
vim.opt.completeopt = { "menuone", "noselect", "noinsert", "popup" }
vim.opt.conceallevel = 2
vim.opt.cursorline = true
vim.opt.diffopt = { "internal", "filler", "closeoff", "hiddenoff" }
vim.opt.equalalways = false
vim.opt.expandtab = false
vim.opt.foldmethod = "marker"
vim.opt.formatoptions = "cqrnj"
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.jumpoptions:append("stack")
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.modeline = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.pumheight = 10
vim.opt.pumwidth = 40
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.sessionoptions = { "buffers", "curdir", "folds", "help", "tabpages", "winsize", "winpos" }
vim.opt.shiftround = true
vim.opt.shiftwidth = 0
vim.opt.shortmess:append("a")
vim.opt.showbreak = string.rep(" ", 3)
vim.opt.signcolumn = "yes:1"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smoothscroll = true
vim.opt.spelloptions = { "camel" }
vim.opt.softtabstop = -1
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.switchbuf = { "useopen", "uselast" }
vim.opt.termguicolors = true
vim.opt.textwidth = 99
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.undolevels = 500
vim.opt.updatetime = 500
vim.opt.wildignore:append({ "*.o", "*.rej", "*.so", "*~", "*.pyc", "*pycache*", "Cargo.lock" })
vim.opt.wildmode = "longest:full,full"
vim.opt.wrap = false

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("options", { clear = true }),
	callback = function()
		---@diagnostic disable-next-line: param-type-mismatch
		vim.opt_local.formatoptions:remove("o")
	end,
})
