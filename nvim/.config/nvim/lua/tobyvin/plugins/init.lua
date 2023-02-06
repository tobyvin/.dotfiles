return {
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
		"tiagovla/scope.nvim",
		event = "VeryLazy",
		config = true,
	},
	{
		"lukas-reineke/virt-column.nvim",
		event = "BufReadPre",
		config = true,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		config = true,
	},
	{
		"numToStr/Comment.nvim",
		version = "*",
		event = "VeryLazy",
		config = true,
	},
	{
		"akinsho/git-conflict.nvim",
		event = "BufReadPre",
		opts = {
			disable_diagnostics = true,
			highlights = {
				incoming = "diffText",
				current = "diffAdd",
			},
		},
	},
	{
		"f3fora/nvim-texlabconfig",
		ft = { "tex", "bib" },
		config = true,
		build = "go build -o ~/.local/bin",
	},
}
