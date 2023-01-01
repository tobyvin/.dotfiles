local M = {
	"rcarriga/cmp-dap",
	ft = { "dap-repl" },
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
}

function M.config()
	require("cmp").setup.filetype({ "dap-repl" }, {
		sources = {
			{ name = "dap" },
		},
	})
end

return M
