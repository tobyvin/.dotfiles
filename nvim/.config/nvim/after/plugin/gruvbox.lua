require("gruvbox").setup({
	contrast = "hard",
	transparent_mode = true,
	overrides = {
		DiffDelete = { link = "GruvboxRed" },
		DiffAdd = { link = "GruvboxGreen" },
		DiffChange = { link = "GruvboxAqua" },
		DiffText = { link = "GruvboxYellow" },
		QuickFixLine = { link = "CursorLine" },
	},
})

vim.cmd.colorscheme("gruvbox")
