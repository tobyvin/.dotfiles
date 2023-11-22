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
		"lukas-reineke/virt-column.nvim",
		event = "BufAdd",
		opts = {},
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
		"NvChad/nvim-colorizer.lua",
		ft = {
			"css",
			"scss",
			"sass",
			"javascript",
			"html",
			"htmldjango",
		},
		opts = {
			filetypes = {
				"css",
				"scss",
				"sass",
				"javascript",
				"html",
				"htmldjango",
			},
			user_default_options = {
				mode = "virtualtext",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
	},
	{
		"f3fora/nvim-texlabconfig",
		build = "go build -o ~/.local/bin",
		ft = { "tex", "bib" },
		opts = {},
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
		"eandrju/cellular-automaton.nvim",
		cmd = "CellularAutomaton",
	},
	{
		"hjson/vim-hjson",
		ft = "hjson",
	},
	{
		"tridactyl/vim-tridactyl",
		ft = "tridactyl",
	},
}

return M
