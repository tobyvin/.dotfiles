---@type LazySpec
local M = {
	"Bilal2453/luvit-meta",
	"LuaCATS/tex-luatex",
	"LuaCATS/tex-lualatex",
	"LuaCATS/tex-luametatex",
	"LuaCATS/tex-lualibs",
	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				"lazy.nvim",
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
				{ path = "tex-luatex", words = { "tex" } },
				{ path = "tex-lualatex", words = { "tex" } },
				{ path = "tex-luametatex", words = { "tex" } },
				{ path = "tex-lualibs", words = { "tex" } },
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
	},
}

return M
