---@type LazySpec
local M = {
	"3rd/image.nvim",
	build = false,
	dependencies = {
		"kiyoon/magick.nvim",
	},
	opts = {
		backend = "sixel",
		only_render_image_at_cursor = true,
		only_render_image_at_cursor_mode = "popup",
	},
}

return M
