---@type LazyPluginSpec
local M = {
	"nvim-telescope/telescope-dap.nvim",
	keys = {
		"<leader>dC",
		"<leader>dd",
	},
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"mfussenegger/nvim-dap",
	},
}

function M:config()
	require("telescope").load_extension("dap")
	local ts_dap = require("telescope").extensions.dap

	vim.keymap.set("n", "<leader>dC", ts_dap.commands, { desc = "commands" })
	vim.keymap.set("n", "<leader>dd", ts_dap.configurations, { desc = "configurations" })
	vim.keymap.set("n", "<leader>dB", ts_dap.list_breakpoints, { desc = "breakpoints" })
	vim.keymap.set("n", "<leader>df", ts_dap.frames, { desc = "frames" })
	vim.keymap.set("n", "<leader>dv", ts_dap.variables, { desc = "variables" })
end

return M
