---@type LazySpec[]
local M = {
	{
		"eandrju/cellular-automaton.nvim",
		cmd = "CellularAutomaton",
	},
	{
		"hjson/vim-hjson",
		ft = "hjson",
	},
	{
		"nfnty/vim-nftables",
		ft = "nftables",
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
