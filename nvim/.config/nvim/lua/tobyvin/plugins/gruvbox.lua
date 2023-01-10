local M = {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		contrast = "hard",
		transparent_mode = true,
		inverse = false,
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
			QuickFixLine = { fg = "", bg = "" },
			StatusLine = { link = "Pmenu" },
			StatusLineNC = { link = "GruvboxNC" },
			WinBar = { link = "GruvboxNC" },
			WinBarNC = { link = "GruvboxFg4" },
		},
	},
}

function M.config(_, opts)
	vim.api.nvim_set_hl(0, "GruvboxNC", {
		fg = require("gruvbox.palette").light4,
		bg = require("gruvbox.palette").dark1,
	})

	require("gruvbox").setup(opts)

	vim.cmd([[colorscheme gruvbox]])
end

return M
