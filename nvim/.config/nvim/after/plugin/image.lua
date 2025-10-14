local success, image = pcall(require, "image")
if not success then
	return
end

image.setup({
	backend = "sixel",
	only_render_image_at_cursor = true,
	only_render_image_at_cursor_mode = "popup",
	integrations = {},
	kitty_method = "normal",
})
