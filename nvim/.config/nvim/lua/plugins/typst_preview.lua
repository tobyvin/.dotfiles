local M = {
	"chomosuke/typst-preview.nvim",
	ft = "typst",
	version = "*",
}

function M:build()
	require("typst-preview").update()
end

return M
