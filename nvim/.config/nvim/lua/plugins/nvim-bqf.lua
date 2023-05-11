local M = {
	"kevinhwang91/nvim-bqf",
	ft = "qf",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
}

function M.config()
	local bqf = require("bqf")

	bqf.setup({
		auto_resize_height = true,
		preview = {
			border_chars = { "│", "│", "─", "─", "┌", "┐", "└", "┘", "█" },
		},
		func_map = {
			open = "o",
			openc = "<cr>",
			tabc = "t",
			tab = "<C-t>",
			pscrollup = "<C-u>",
			pscrolldown = "<C-d>",
		},
	})
end

return M
