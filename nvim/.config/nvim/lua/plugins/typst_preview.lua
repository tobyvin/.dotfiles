---@type LazySpec
local M = {
	"chomosuke/typst-preview.nvim",
	ft = "typst",
	opts = {
		invert_colors = "auto",
	},
}

function M:build()
	require("typst-preview").update()
end

return M
