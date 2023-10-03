---@type LazyPluginSpec
local M = {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = true,
}

function M.init()
	vim.keymap.set("v", "<leader>rr", function()
		require("refactoring").select_refactor({})
	end, { desc = "refactor" })

	vim.keymap.set("n", "<leader>ri", function()
		require("refactoring").refactor("Inline Variable")
	end, { desc = "inline variable" })

	vim.keymap.set("n", "<leader>rb", function()
		require("refactoring").refactor("Extract Block")
	end, { desc = "extract block" })

	vim.keymap.set("n", "<leader>rf", function()
		require("refactoring").refactor("Extract Block To File")
	end, { desc = "extract block to file" })
end

return M
