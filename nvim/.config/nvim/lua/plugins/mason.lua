---@type LazyPluginSpec
local M = {
	"williamboman/mason.nvim",
	version = "*",
	build = ":MasonUpdate",
	lazy = false,
	dependencies = {
		{
			"zapling/mason-lock.nvim",
			lazy = false,
			opts = {},
		},
	},
	opts = {
		ui = {
			border = "single",
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
}

return M
