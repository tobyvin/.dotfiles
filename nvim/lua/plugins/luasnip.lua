local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
	return
end

luasnip.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI"
})

luasnip.snippets = {all = {}, html = {}}

luasnip.snippets.javascript = luasnip.snippets.html
luasnip.snippets.javascriptreact = luasnip.snippets.html
luasnip.snippets.typescriptreact = luasnip.snippets.html
require("luasnip.loaders.from_vscode").load({include = {"html"}})

require('luasnip.loaders.from_vscode').lazy_load()