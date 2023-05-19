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
		"luukvbaal/statuscol.nvim",
		event = "VeryLazy",
		config = true,
	},
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			filetypes = { "*" },
			user_default_options = {
				mode = "virtualtext", -- Set the display mode.
				always_update = true,
			},
		},
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
		"yorik1984/zola.nvim",
		ft = "markdown",
		dependencies = "Glench/Vim-Jinja2-Syntax",
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
