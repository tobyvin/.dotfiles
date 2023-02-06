local M = {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		contrast = "hard",
		transparent_mode = true,
		inverse = false,
	},
}

function M.config(_, opts)
	require("gruvbox").setup(opts)

	local config = require("gruvbox").config
	local colors = require("gruvbox.palette").get_base_colors(config.bg, config.contrast)

	config.overrides = {
		GruvboxNC = { fg = colors.fg4, bg = colors.bg1 },
		NormalFloat = { bg = "" },
		FloatBorder = { bg = "" },
		ColorColumn = { bg = "" },
		CursorLine = { bg = "" },
		CursorLineNr = { bg = "" },
		QuickFixLine = { fg = "", bg = "" },
		StatusLine = { link = "Pmenu" },
		StatusLineNC = { link = "GruvboxNC" },
		StatusLineNCB = { fg = colors.fg4, bg = colors.bg1, bold = config.bold },
		StatusLineNormal = { fg = colors.bg0, bg = colors.fg4, bold = config.bold },
		StatusLineOperator = { link = "StatusLineNormal" },
		StatusLineVisual = { fg = colors.bg0, bg = colors.orange, bold = config.bold },
		StatusLineVLine = { link = "StatusLineVisual" },
		StatusLineVBlock = { link = "StatusLineVisual" },
		StatusLineSelect = { link = "StatusLineVisual" },
		StatusLineSLine = { link = "StatusLineVisual" },
		StatusLineSBlock = { link = "StatusLineVisual" },
		StatusLineInsert = { fg = colors.bg0, bg = colors.blue, bold = config.bold },
		StatusLineReplace = { fg = colors.bg0, bg = colors.aqua, bold = config.bold },
		StatusLineCommand = { fg = colors.bg0, bg = colors.green, bold = config.bold },
		StatusLinePrompt = { link = "StatusLineCommand" },
		StatusLineConfirm = { link = "StatusLinePrompt" },
		StatusLineMore = { link = "StatusLinePrompt" },
		StatusLineEx = { link = "StatusLineCommand" },
		StatusLineTerminal = { link = "StatusLineEx" },
		WinBar = { link = "GruvboxNC" },
		WinBarNC = { link = "GruvboxFg4" },
		IndentContext1 = { link = "GruvboxRed" },
		IndentContext2 = { link = "GruvboxOrange" },
		IndentContext3 = { link = "GruvboxYellow" },
		IndentContext4 = { link = "GruvboxGreen" },
		IndentContext5 = { link = "GruvboxAqua" },
		IndentContext6 = { link = "GruvboxBlue" },
		IndentContext7 = { link = "GruvboxViolet" },
	}

	vim.cmd.colorscheme("gruvbox")
end

return M
