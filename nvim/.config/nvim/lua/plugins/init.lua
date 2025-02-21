---@type LazySpec
local M = {
	{
		"nvim-lua/plenary.nvim",
		version = false,
		optional = true,
	},
	{
		"eandrju/cellular-automaton.nvim",
		cmd = "CellularAutomaton",
	},
	{
		"rktjmp/playtime.nvim",
		cmd = "Playtime",
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
		"nmac427/guess-indent.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
	{
		"f3fora/nvim-texlabconfig",
		version = false,
		build = "go build -o /home/tobyv/.local/bin/",
		ft = { "tex", "bib" },
		opts = {},
	},
}

return M
