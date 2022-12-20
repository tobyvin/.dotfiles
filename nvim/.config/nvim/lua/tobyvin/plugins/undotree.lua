local M = {
	"jiaoshijie/undotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}

function M.config()
	local undotree = require("undotree")

	undotree.setup({
		window = {
			winblend = 0,
		},
	})
end

return M
