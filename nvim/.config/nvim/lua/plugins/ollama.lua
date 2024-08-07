---@type LazySpec
local M = {
	"nvim-lua/plenary.nvim",
	{
		"nomnivore/ollama.nvim",
		cmd = {
			"Ollama",
			"OllamaModel",
		},
		opts = {
			model = "deepseek-coder:6.7b",
		},
	},
}

return M
