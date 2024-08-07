---@type LazySpec
local M = {
	"vxpm/ferris.nvim",
	version = false,
	ft = { "rust" },
	opts = {
		url_handler = vim.ui.open,
	},
}

return M
