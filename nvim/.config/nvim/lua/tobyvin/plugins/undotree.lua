local M = {
	"jiaoshijie/undotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = "UndoTree",
	opts = {
		window = {
			winblend = 0,
		},
	},
}

function M.init()
	vim.api.nvim_create_user_command("UndoTree", function()
		require("undotree").open()
	end, { desc = "toggle undotree" })
end

return M
