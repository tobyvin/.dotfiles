---@type LazyPluginSpec
local M = {
	"rcarriga/cmp-dap",
	ft = { "dap-repl" },
	dependencies = {
		"mfussenegger/nvim-dap",
		"hrsh7th/nvim-cmp",
	},
}

function M:config()
	---@diagnostic disable-next-line: missing-fields
	require("cmp").setup.filetype({ "dap-repl" }, {
		sources = {
			{ name = "dap" },
		},
	})
end

return M
