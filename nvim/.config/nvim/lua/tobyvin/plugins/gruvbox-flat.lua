local M = {}

M.setup = function()
	vim.opt.background = "dark"
	local colors = require("gruvbox.colors").setup()
	vim.g.gruvbox_colors = { bg_statusline = colors.line_cursor }
	vim.g.gruvbox_flat_style = "hard"
	vim.g.gruvbox_transparent = true
	vim.cmd([[colorscheme gruvbox-flat]])
end

return M
