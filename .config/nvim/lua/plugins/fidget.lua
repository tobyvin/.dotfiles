local M = {
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
}

return M
