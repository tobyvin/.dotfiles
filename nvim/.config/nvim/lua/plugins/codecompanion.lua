---@type LazySpec
local M = {
	"nvim-lua/plenary.nvim",
	"nvim-treesitter/nvim-treesitter",
	{
		"olimorris/codecompanion.nvim",
		cmd = {
			"CodeCompanion",
			"CodeCompanionChat",
			"CodeCompanionActions",
			"CodeCompanionToggle",
			"CodeCompanionAdd",
		},
		opts = {
			strategies = {
				chat = {
					adapter = "ollama",
				},
				inline = {
					adapter = "ollama",
				},
				agent = {
					adapter = "ollama",
				},
			},
		},
	},
}

return M
