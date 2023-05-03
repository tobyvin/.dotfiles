---@type LazyPluginSpec
local M = {
	"numToStr/Comment.nvim",
	version = "*",
	event = "BufReadPre",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
}

function M:config(opts)
	opts.pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
	require("Comment").setup(opts)
end

return M
