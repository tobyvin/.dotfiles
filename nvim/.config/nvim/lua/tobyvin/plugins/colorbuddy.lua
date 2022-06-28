local M = {}

M.setup = function()
	local status_ok, colorbuddy = pcall(require, "colorbuddy")
	if not status_ok then
		vim.notify("Failed to load module 'colorbuddy'", "error")
		return
	end

	vim.opt.termguicolors = true

	colorbuddy.colorscheme("gruvbuddy")

	local c = require("colorbuddy.color").colors
	local Group = require("colorbuddy.group").Group
	local g = require("colorbuddy.group").groups
	local s = require("colorbuddy.style").styles

	Group.new("GoTestSuccess", c.green, nil, s.bold)
	Group.new("GoTestFail", c.red, nil, s.bold)

	-- Group.new('Keyword', c.purple, nil, nil)

	Group.new("TSPunctBracket", c.orange:light():light())

	Group.new("StatuslineError1", c.red:light():light(), g.Statusline)
	Group.new("StatuslineError2", c.red:light(), g.Statusline)
	Group.new("StatuslineError3", c.red, g.Statusline)
	Group.new("StatuslineError3", c.red:dark(), g.Statusline)
	Group.new("StatuslineError3", c.red:dark():dark(), g.Statusline)

	Group.new("pythonTSType", c.red)
	Group.new("goTSType", g.Type.fg:dark(), nil, g.Type)

	Group.new("typescriptTSConstructor", g.pythonTSType)
	Group.new("typescriptTSProperty", c.blue)

	-- vim.cmd [[highlight WinSeparator guifg=#4e545c guibg=None]]
	Group.new("WinSeparator", nil, nil)

	-- I don't think I like highlights for text
	-- Group.new("LspReferenceText", nil, c.gray0:light(), s.bold)
	-- Group.new("LspReferenceWrite", nil, c.gray0:light())

	-- Group.new("TSKeyword", c.purple, nil, s.underline, c.blue)
	-- Group.new("LuaFunctionCall", c.green, nil, s.underline + s.nocombine, g.TSKeyword.guisp)

	-- Hello
	Group.new("TSTitle", c.blue)
end

M.colors = function()
	return require("colorbuddy.color").colors
end

return M
