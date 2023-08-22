---@type LazyPluginSpec
local M = {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	opts = {
		cmd = { "jdtls" },
	},
}

function M:config(opts)
	require("jdtls").start_or_attach(opts)
end

return M
