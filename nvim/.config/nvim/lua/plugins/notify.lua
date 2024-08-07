---@type LazySpec
local M = {
	"rcarriga/nvim-notify",
	opts = {
		max_width = math.min(vim.o.columns, 80),
		render = "wrapped-compact",
		stages = "no_animation",
	},
}

function M:init()
	---@diagnostic disable-next-line: duplicate-set-field
	vim.notify = function(...)
		return require("notify").notify(...)
	end
end

return M
