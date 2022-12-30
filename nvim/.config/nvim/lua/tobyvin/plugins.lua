return {
	"nvim-lua/plenary.nvim",
	{
		"folke/lazy.nvim",
		version = "*",
		init = function()
			vim.keymap.set("n", "<leader>p", function()
				require("lazy.view").show("home")
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
		version = "*",
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
