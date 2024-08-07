---@type LazySpec
local M = {
	"j-hui/fidget.nvim",
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
