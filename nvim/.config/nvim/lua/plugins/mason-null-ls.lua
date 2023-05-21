---@type LazySpec
local M = {
	"jayp0521/mason-null-ls.nvim",
	version = "*",
	cmd = {
		"NullLsInstall",
		"NullLsUninstall",
	},
	dependencies = { "williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim" },
	opts = {
		handlers = {},
	},
}

return M
