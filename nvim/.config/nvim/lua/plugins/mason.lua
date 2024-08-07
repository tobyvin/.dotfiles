---@type LazySpec
local M = {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	lazy = false,
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
