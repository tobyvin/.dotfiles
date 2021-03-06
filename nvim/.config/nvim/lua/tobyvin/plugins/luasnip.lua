local M = {}

M.setup = function()
	local status_ok, luasnip = pcall(require, "luasnip")
	if not status_ok then
		return
	end

	luasnip.config.set_config({
		history = true,
		updateevents = "TextChanged,TextChangedI",
	})

	luasnip.snippets = require("luasnip_snippets").load_snippets()

	require("luasnip.loaders.from_vscode").lazy_load()
end

return M
