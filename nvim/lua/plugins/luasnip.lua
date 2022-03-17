require("luasnip").config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI"
})

require("luasnip").snippets = {all = {}, html = {}}

require("luasnip").snippets.javascript = require("luasnip").snippets.html
require("luasnip").snippets.javascriptreact = require("luasnip").snippets.html
require("luasnip").snippets.typescriptreact = require("luasnip").snippets.html
require("luasnip/loaders/from_vscode").load({include = {"html"}})

require('luasnip/loaders/from_vscode').lazy_load()