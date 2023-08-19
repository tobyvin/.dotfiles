local M = {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	opts = {
		contrast = "hard",
		transparent_mode = true,
		overrides = {
			DiffDelete = { reverse = false },
			DiffAdd = { reverse = false },
			DiffChange = { reverse = false },
			DiffText = { reverse = false },
			IndentContext1 = { link = "GruvboxRed" },
			IndentContext2 = { link = "GruvboxOrange" },
			IndentContext3 = { link = "GruvboxYellow" },
			IndentContext4 = { link = "GruvboxGreen" },
			IndentContext5 = { link = "GruvboxAqua" },
			IndentContext6 = { link = "GruvboxBlue" },
			IndentContext7 = { link = "GruvboxPurple" },
		},
	},
}

return M
