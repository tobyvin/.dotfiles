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
		"j-hui/fidget.nvim",
		version = "*",
		event = { "LspAttach" },
    cmd = "Fidget",
		opts = {
			notification = {
				window = {
					winblend = 0,
				},
			},
		},
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
		opts = {
			separator = "─",
			multiline_threshold = 1,
		},
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
	{
		"sourcegraph/sg.nvim",
		cmd = {
			"CodyDo",
			"CodyAsk",
			"CodyChat",
			"CodyTask",
			"CodyToggle",
			"CodyRestart",
			"CodyTaskNext",
			"CodyTaskPrev",
			"CodyTaskView",
			"CodyTaskAccept",
			"SourcegraphInfo",
			"SourcegraphLink",
			"SourcegraphBuild",
			"SourcegraphLogin",
			"SourcegraphSearch",
			"SourcegraphDownloadBinaries",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = {},
	},
}

return M
