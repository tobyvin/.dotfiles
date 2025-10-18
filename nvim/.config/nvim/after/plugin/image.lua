-- Don't load if running headless due to error getting term size on the follow line,
-- https://github.com/3rd/image.nvim/blob/446a8a5cc7a3eae3185ee0c697732c32a5547a0b/lua/image/utils/term.lua#L34
if #vim.api.nvim_list_uis() == 0 then
	return
end
require("image").setup({
	backend = "sixel",
	only_render_image_at_cursor = true,
	only_render_image_at_cursor_mode = "popup",
	integrations = {},
	kitty_method = "normal",
})
