vim.g.mapleader = " "
vim.g.maplocalleader = vim.g.mapleader
vim.g.loaded_perl_provider = 0

require("lazy")

pcall(vim.cmd.colorscheme, "gruvbox")
