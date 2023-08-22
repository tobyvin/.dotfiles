---@type LazyPluginSpec
local M = {
	"RubixDev/mason-update-all",
	cmd = {
		"MasonUpdateAll",
	},
	dependencies = { "williamboman/mason.nvim" },
	config = true,
}

return M
