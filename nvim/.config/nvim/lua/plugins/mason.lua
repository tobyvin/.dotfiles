---@type LazyPluginSpec
local M = {
	"williamboman/mason.nvim",
	version = "*",
	build = ":MasonUpdate",
  lazy = false,
	dependencies = {},
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
