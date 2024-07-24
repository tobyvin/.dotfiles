---@type LazyPluginSpec
local M = {
	"rcarriga/nvim-notify",
	version = "*",
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

function M:init()
	---@diagnostic disable-next-line: duplicate-set-field
	vim.notify = function(...)
		-- TODO: fix for bug in conform causing `err.message` to be nil in notify callback
		if select(1, ...) == nil then
			return
		end
		return require("notify").notify(...)
	end
end

return M
