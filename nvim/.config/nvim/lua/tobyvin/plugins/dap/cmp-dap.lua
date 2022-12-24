local M = {
	"rcarriga/cmp-dap",
	ft = { "dap-repl", "dapui_watches", "dapui_hover" },
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
}

function M.config()
	require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
		sources = {
			{ name = "dap" },
		},
	})
end

return M
