local M = {
	"ThePrimeagen/refactoring.nvim",
}

function M.init()
	vim.keymap.set("v", "<leader>r", function()
		require("refactoring").select_refactor()
	end, { desc = "refactor" })
end

function M.config()
	require("refactoring").setup({})
end

return M
