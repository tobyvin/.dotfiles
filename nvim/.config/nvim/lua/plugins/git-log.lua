local M = {
	"niuiic/git-log.nvim",
	dependencies = {
		"niuiic/core.nvim",
	},
	opts = {
		win = {
			border = "single",
		},
	},
}

function M:init()
	vim.keymap.set({ "n", "v" }, "<leader>gl", function()
		require("git-log").check_log()
	end, { desc = "show git log" })
end

return M
