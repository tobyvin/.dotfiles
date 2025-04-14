---@type LazySpec
local M = {
	{
		"emmanueltouzery/plenary.nvim",
		branch = "winborder",
		version = false,
		optional = true,
	},
	{
		"f3fora/nvim-texlabconfig",
		version = false,
		build = "go build -o /home/tobyv/.local/bin/",
		ft = { "tex", "bib" },
		opts = {},
	},
	{
		"tridactyl/vim-tridactyl",
		ft = "tridactyl",
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
		"wilriker/gcode.vim",
		ft = "gcode",
	},
	{
		"eandrju/cellular-automaton.nvim",
		cmd = "CellularAutomaton",
	},
	{
		"rktjmp/playtime.nvim",
		cmd = "Playtime",
	},
}

return M
