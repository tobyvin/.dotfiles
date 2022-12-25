return {
	"nvim-lua/plenary.nvim",
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
		event = "VeryLazy",
		config = true,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		config = true,
	},
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = true,
	},
	{
		"akinsho/git-conflict.nvim",
		event = "BufReadPre",
		config = {
			disable_diagnostics = true,
			highlights = {
				incoming = "diffText",
				current = "diffAdd",
			},
		},
	},
}
