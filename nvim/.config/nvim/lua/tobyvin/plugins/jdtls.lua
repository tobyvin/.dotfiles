local M = {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	opts = {
		cmd = { "jdtls" },
	},
}

function M.config(_, opts)
	require("jdtls").start_or_attach(opts)
end

return M
