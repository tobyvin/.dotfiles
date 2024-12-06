local M = {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	version = false,
	opts = {
		cmd = { "jdtls" },
	},
}

function M:config(opts)
	require("jdtls").start_or_attach(opts)
end

return M
