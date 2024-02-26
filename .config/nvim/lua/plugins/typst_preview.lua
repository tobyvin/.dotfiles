local M = {
	"chomosuke/typst-preview.nvim",
	ft = "typst",
	version = "*",
	opts = {
		invert_colors = "auto",
	},
}

function M:build()
	require("typst-preview").update()
end

return M
