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
			filetypes = {
				"css",
				"javascript",
				"html",
				"htmldjango",
			},
			user_default_options = {
				mode = "virtualtext",
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
		"toppair/peek.nvim",
		build = "deno task --quiet build:fast",
		enabled = function()
			return vim.fn.executable("deno") == 1
		end,
		opts = {
			auto_load = false,
			close_on_bdelete = true,
			syntax = true,
			update_on_change = true,
			app = "webview",
			filetype = { "markdown" },
		},
		init = function()
			vim.api.nvim_create_user_command("PeekOpen", function()
				require("peek").open()
			end, { desc = "open peek.nvim markdown preview" })

			vim.api.nvim_create_user_command("PeekClose", function()
				require("peek").close()
			end, { desc = "close peek.nvim markdown preview" })
		end,
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
