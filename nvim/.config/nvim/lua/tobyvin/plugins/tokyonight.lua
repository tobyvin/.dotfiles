local M = {
	"folke/tokyonight.nvim",
}

function M.config()
	local tokyonight = require("tokyonight")

	tokyonight.setup({
		styles = {
			sidebars = "transparent",
			floats = "transparent",
		},
		transparent = true,
	})
end

return M
