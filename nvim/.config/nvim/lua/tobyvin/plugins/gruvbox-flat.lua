local M = {}

M.setup = function()
	vim.opt.background = "dark"
	vim.g.gruvbox_flat_style = "hard"
	vim.g.gruvbox_transparent = true

	local theme = require("gruvbox.theme").setup({})

	vim.g.gruvbox_theme = {
		debugBreakpoint = { bg = theme.base.SignColumn.bg, fg = "error" },
	}

	vim.cmd([[colorscheme gruvbox-flat]])
end

return M
