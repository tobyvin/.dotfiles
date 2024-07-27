---@type LazyPluginSpec
local M = {
	"vxpm/ferris.nvim",
	ft = { "rust" },
	opts = {
		url_handler = vim.ui.open,
	},
}

return M
