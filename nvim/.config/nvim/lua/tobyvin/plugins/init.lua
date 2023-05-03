---@type LazySpec[]
local M = {
	"nvim-lua/plenary.nvim",
	{
		"folke/lazy.nvim",
		version = "*",
		init = function()
			vim.keymap.set("n", "<leader>p", function()
				require("lazy").home()
			end, { desc = "plugins" })
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		event = "BufReadPre",
	},
	{
		"lukas-reineke/virt-column.nvim",
		event = "BufReadPre",
		config = true,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = true,
	},
	{
		"akinsho/git-conflict.nvim",
		event = "BufReadPre",
		opts = {
			disable_diagnostics = true,
		},
	},
	{
		"f3fora/nvim-texlabconfig",
		ft = { "tex", "bib" },
		config = true,
		build = "go build -o ~/.local/bin",
	},
	{
		"kwkarlwang/bufjump.nvim",
		event = "VeryLazy",
		config = true,
		opts = {
			forward = "gn",
			backward = "gp",
			on_success = nil,
		},
	},
	{
		"anuvyklack/pretty-fold.nvim",
		event = "VeryLazy",
		config = true,
	},
	{
		"eandrju/cellular-automaton.nvim",
		cmd = "CellularAutomaton",
	},
}

return M
