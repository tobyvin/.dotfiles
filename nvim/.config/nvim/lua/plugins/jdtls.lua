local M = {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	version = false,
	opts = {
		cmd = { "jdtls" },
	},
}

function M:config(opts)
	require(self.main).start_or_attach(opts)
end

return M
