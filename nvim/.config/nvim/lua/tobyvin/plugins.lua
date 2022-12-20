return {
	"lewis6991/impatient.nvim",
	"nvim-lua/plenary.nvim",
	"ThePrimeagen/harpoon",
	"norcalli/nvim-colorizer.lua",
	"b0o/SchemaStore.nvim",
	{
		"nacro90/numb.nvim",
		config = function()
			require("numb").setup()
		end,
	},
	{
		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup()
		end,
	},
	{
		"lukas-reineke/virt-column.nvim",
		config = function()
			require("virt-column").setup()
		end,
	},
	{
		"petertriho/cmp-git",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("cmp_git").setup()
		end,
	},
	{
		"David-Kunz/cmp-npm",
		event = "BufRead package.json",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("cmp-npm").setup()
		end,
	},
	{
		"onsails/lspkind-nvim",
		config = function()
			require("lspkind").init()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		config = function()
			require("treesitter-context").setup()
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("nvim-dap-virtual-text").setup({})
		end,
	},
	{
		"ur4ltz/surround.nvim",
		config = function()
			require("surround").setup({})
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
}
