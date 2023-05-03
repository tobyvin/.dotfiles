local M = {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	opts = {
		contrast = "hard",
		transparent_mode = true,
		overrides = {
			CursorLineNr = { bg = "" },
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
			IndentContext7 = { link = "GruvboxViolet" },

			-- See: https://github.com/ellisonleao/gruvbox.nvim/pull/255
			["@lsp.type.class"] = { link = "@type" },
			["@lsp.type.decorator"] = { link = "@macro" },
			["@lsp.type.interface"] = { link = "@constructor" },
			["@lsp.type.struct"] = { link = "@type" },
		},
	},
}

return M
