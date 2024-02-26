local M = {
	"nvim-treesitter/nvim-treesitter-context",
	event = "BufReadPre",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		separator = "─",
		multiline_threshold = 1,
	},
}

return M
