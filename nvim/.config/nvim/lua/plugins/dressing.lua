---@type LazyPluginSpec
local M = {
	"stevearc/dressing.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	opts = {},
}

function M.init()
	---@diagnostic disable-next-line: duplicate-set-field
	vim.ui.select = function(...)
		require("lazy").load({ plugins = { "dressing.nvim" } })
		return vim.ui.select(...)
	end

	---@diagnostic disable-next-line: duplicate-set-field
	vim.ui.input = function(...)
		require("lazy").load({ plugins = { "dressing.nvim" } })
		return vim.ui.input(...)
	end
end

return M
