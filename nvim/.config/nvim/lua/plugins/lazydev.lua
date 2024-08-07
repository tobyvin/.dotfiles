---@type LazySpec
local M = {
	"folke/lazydev.nvim",
	ft = "lua",
	cmd = "LazyDev",
	dependencies = {
		"Bilal2453/luvit-meta",
	},
	opts = {
		library = {
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
			"lazy.nvim",
		},
	},
	specs = {
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
}

return M
