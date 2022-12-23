local M = {
	"jiaoshijie/undotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = "UndoTree",
	config = {
		window = {
			winblend = 0,
		},
	},
}

function M.init()
	-- TODO: fix this not registering as a command
	vim.api.nvim_create_user_command("UndoTree", function()
		require("undotree").open()
	end)
end

return M
