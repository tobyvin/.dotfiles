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
		registries = {
			-- TODO: remove once mdformat-gfm is added to official registry
			-- Ref: https://github.com/mason-org/mason-registry/pull/3900
			"lua:custom-registry",
			"github:mason-org/mason-registry",
		},
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
