local M = {
	"ThePrimeagen/refactoring.nvim",
	config = true,
}

function M.init()
	vim.keymap.set("v", "<leader>rr", function()
		require("refactoring").select_refactor()
	end, { desc = "refactor" })
end

return M
