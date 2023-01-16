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
			IndentBlanklineContext1 = { link = "GruvboxRed" },
			IndentBlanklineContext2 = { link = "GruvboxOrange" },
			IndentBlanklineContext3 = { link = "GruvboxYellow" },
			IndentBlanklineContext4 = { link = "GruvboxGreen" },
			IndentBlanklineContext5 = { link = "GruvboxAqua" },
			IndentBlanklineContext6 = { link = "GruvboxBlue" },
			IndentBlanklineContext7 = { link = "GruvboxViolet" },
		},
	},
}

function M.config(_, opts)
	vim.api.nvim_set_hl(0, "GruvboxNC", {
		fg = require("gruvbox.palette").light4,
		bg = require("gruvbox.palette").dark1,
	})

	require("gruvbox").setup(opts)

	vim.cmd.colorscheme("gruvbox")
end

return M
