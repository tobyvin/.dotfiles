local M = {
	"nvim-telescope/telescope-dap.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
}

function M.init()
	vim.keymap.set("n", "<leader>dC", function()
		require("telescope").extensions.dap.commands()
	end, { desc = "commands" })

	vim.keymap.set("n", "<leader>dd", function()
		require("telescope").extensions.dap.configurations()
	end, { desc = "configurations" })

	vim.keymap.set("n", "<leader>dl", function()
		require("telescope").extensions.dap.list_breakpoints()
	end, { desc = "breakpoints" })

	vim.keymap.set("n", "<leader>df", function()
		require("telescope").extensions.dap.frames()
	end, { desc = "frames" })

	vim.keymap.set("n", "<leader>dv", function()
		require("telescope").extensions.dap.variables()
	end, { desc = "variables" })
end

function M.config()
	require("telescope").load_extension("dap")
end

return M
