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
		"wilriker/gcode.vim",
		ft = "gcode",
	},
	{
		"neovim/nvim-lspconfig",
		version = false,
	},
	{
		"tridactyl/vim-tridactyl",
		ft = "tridactyl",
	},
	{
		"f3fora/nvim-texlabconfig",
		version = false,
		build = "go build -o /home/tobyv/.local/bin/",
		ft = { "tex", "bib" },
		opts = {},
	},
	{
		"brianhuster/live-preview.nvim",
		ft = { "html" },
	},
}

return M
