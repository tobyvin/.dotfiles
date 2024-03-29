---@type LazyPluginSpec
local M = {
	"rcarriga/nvim-notify",
	opts = {
		timeout = 3000,
		background_colour = "Pmenu",
		max_height = function()
			return math.floor(vim.o.lines * 0.75)
		end,
		max_width = function()
			return math.floor(vim.o.columns * 0.75)
		end,
		render = "wrapped-compact",
	},
}

return M
