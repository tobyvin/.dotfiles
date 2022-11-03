local M = {}

M.setup = function()
	local status_ok, gruvbox = pcall(require, "gruvbox")
	if not status_ok then
		vim.notify("Failed to load module 'gruvbox'", vim.log.levels.ERROR)
		return
	end

	local colors = require("gruvbox.palette")
	gruvbox.setup({
		overrides = {
			GruvboxRedSign = { bg = "" },
			GruvboxGreenSign = { bg = "" },
			GruvboxYellowSign = { bg = "" },
			GruvboxBlueSign = { bg = "" },
			GruvboxPurpleSign = { bg = "" },
			GruvboxAquaSign = { bg = "" },
			GruvboxOrangeSign = { bg = "" },
			NormalFloat = { bg = "" },
			FloatBorder = { bg = "" },
			ColorColumn = { bg = "" },
			CursorLine = { bg = "" },
			CursorLineNr = { bg = "" },
			SignColumn = { bg = "" },
			DiffDelete = { reverse = false },
			DiffAdd = { reverse = false },
			DiffChange = { reverse = false },
			DiffText = { reverse = false },
			StatusLine = { fg = colors.light1, bg = colors.dark2, reverse = false },
			StatusLineNC = { fg = colors.light4, bg = colors.dark1, reverse = false },
			WinBar = { link = "StatusLineNC" },
			WinBarNC = { fg = colors.light4, bg = "" },
			QuickFixLine = { fg = "", bg = "" },

			-- TODO: workaround for weird highlights in lsp hover/signature
			-- SEE: https://github.com/neovim/neovim/issues/13746
			markdownError = { link = "Normal" },
		},
		transparent_mode = true,
	})

	vim.cmd([[colorscheme gruvbox]])
end

return M
