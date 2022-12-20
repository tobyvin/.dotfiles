local M = {
	"L3MON4D3/LuaSnip",
	dependencies = {
		{
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		"molleweide/LuaSnip-snippets.nvim",
	},
}

function M.config()
	local luasnip = require("luasnip")

	luasnip.config.set_config({
		updateevents = "TextChanged,TextChangedI",
	})

	luasnip.snippets = require("luasnip_snippets").load_snippets()
end

return M
