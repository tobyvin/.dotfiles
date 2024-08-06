local M = {
	"nomnivore/ollama.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = {
		"Ollama",
		"OllamaModel",
	},
	opts = {
		model = "deepseek-coder:6.7b",
	},
}

return M
