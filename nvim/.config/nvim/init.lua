U = require("tobyvin.utils")
vim.ui.select = U.ui.select
vim.ui.input = U.ui.input
require("tobyvin.options")
require("tobyvin.filetype")
require("tobyvin.autocmds")
require("tobyvin.keymaps")
require("tobyvin.commands")
require("tobyvin.lsp")
require("tobyvin.diagnostic")
require("tobyvin.lazy")

pcall(vim.cmd.colorscheme, "gruvbox")
