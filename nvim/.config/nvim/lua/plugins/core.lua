local function setup_with(func_name)
	---@param plugin LazyPlugin
	return function(plugin, opts)
		pcall(require, plugin.main)[func_name](opts)
	end
end

---@type LazySpec[]
local M = {
	"nvim-lua/plenary.nvim",
	{
		"folke/lazy.nvim",
		version = "*",
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
			default_mappings = {
				prev = "[x",
				next = "]x",
			},
		},
	},
	{
		"f3fora/nvim-texlabconfig",
		ft = { "tex", "bib" },
		config = true,
		build = "go build -o ~/.local/bin",
	},
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		opts = {
			cmd = { "jdtls" },
		},
		config = setup_with("start_or_attach"),
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
	{
		"hjson/vim-hjson",
		event = "BufReadPre",
	},
}

return M
