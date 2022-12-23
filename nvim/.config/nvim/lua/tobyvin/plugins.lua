return {
	"nvim-lua/plenary.nvim",
	"ThePrimeagen/harpoon",
	"norcalli/nvim-colorizer.lua",
	"b0o/SchemaStore.nvim",
	{
		"nacro90/numb.nvim",
		config = true,
	},
	{
		"tiagovla/scope.nvim",
		config = true,
	},
	{
		"lukas-reineke/virt-column.nvim",
		config = true,
	},
	{
		"petertriho/cmp-git",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},
	{
		"David-Kunz/cmp-npm",
		event = "BufRead package.json",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		config = true,
	},
	{
		"ur4ltz/surround.nvim",
		config = true,
	},
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = true,
	},
}
