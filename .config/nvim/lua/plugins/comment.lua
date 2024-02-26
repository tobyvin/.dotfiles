---@type LazyPluginSpec
local M = {
	"numToStr/Comment.nvim",
	version = "*",
	event = "BufReadPre",
	dependencies = {
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			event = "BufReadPre",
			opts = {},
			init = function()
				vim.g.skip_ts_context_commentstring_module = true
			end,
		},
	},
	opts = {
		pre_hook = function(...)
			return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(...)
		end,
	},
}

return M
