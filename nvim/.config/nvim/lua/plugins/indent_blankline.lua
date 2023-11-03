---@type LazyPluginSpec
local M = {
	"lukas-reineke/indent-blankline.nvim",
	version = "*",
	event = "BufReadPre",
	main = "ibl",
	opts = {
		scope = {
			show_start = false,
			show_end = false,
		},
	},
}

return M
