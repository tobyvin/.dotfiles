---@type LazyPluginSpec
local M = {
	"folke/lazydev.nvim",
	ft = "lua",
	cmd = "LazyDev",
	dependencies = {
		"Bilal2453/luvit-meta",
		{
			"hrsh7th/nvim-cmp",
			opts = function(_, opts)
				opts.sources = opts.sources or {}
				table.insert(opts.sources, {
					name = "lazydev",
					group_index = 0,
				})
			end,
		},
	},
	opts = {
		library = {
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
			"lazy.nvim",
		},
	},
}

return M
