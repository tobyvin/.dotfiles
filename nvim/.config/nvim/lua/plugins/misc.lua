---@type LazySpec[]
local M = {
	{
		"lukas-reineke/indent-blankline.nvim",
		version = "*",
		event = "BufReadPre",
		main = "ibl",
		opts = {
			scope = {
				show_start = false,
				show_end = false,
			},
		},
	},
	{
		"lukas-reineke/virt-column.nvim",
		event = "BufAdd",
		opts = {},
	},
	{
		"eandrju/cellular-automaton.nvim",
		cmd = "CellularAutomaton",
	},
	{
		"hjson/vim-hjson",
		ft = "hjson",
	},
	{
		"tridactyl/vim-tridactyl",
		ft = "tridactyl",
	},
	{
		"f3fora/nvim-texlabconfig",
		build = "go build -o ~/.local/bin",
		ft = { "tex", "bib" },
		opts = {},
	},
}

return M
