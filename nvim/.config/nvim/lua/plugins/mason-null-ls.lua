---@type LazySpec
local M = {
	"jayp0521/mason-null-ls.nvim",
	version = "*",
	cmd = {
		"NullLsInstall",
		"NullLsUninstall",
	},
	dependencies = { "williamboman/mason.nvim" },
	opts = {
		handlers = {},
	},
}

return M
