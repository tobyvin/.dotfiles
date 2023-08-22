---@type LazyPluginSpec
local M = {
	"jayp0521/mason-nvim-dap.nvim",
	version = "*",
	cmd = {
		"DapInstall",
		"DapUninstall",
	},
	dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
	opts = {
		handlers = {},
	},
}

return M
