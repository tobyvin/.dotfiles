local M = {
	options = require("tobyvin.options"),
	autocmds = require("tobyvin.autocmds"),
	keymaps = require("tobyvin.keymaps"),
	plugins = require("tobyvin.plugins"),
	diagnostic = require("tobyvin.diagnostic"),
	lsp = require("tobyvin.lsp"),
}

M.setup = function()
	M.options.setup()
	M.autocmds.setup()
	M.keymaps.setup()
	M.plugins.setup()
	M.diagnostic.setup()
	M.lsp.setup()
end

return M
