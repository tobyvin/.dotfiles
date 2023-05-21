---@type LazySpec
local M = {
	{
		"williamboman/mason.nvim",
		version = "*",
		build = ":MasonUpdate",
		cmd = {
			"Mason",
			"MasonLog",
			"MasonInstall",
			"MasonUninstall",
		},
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
	},
}

return M
