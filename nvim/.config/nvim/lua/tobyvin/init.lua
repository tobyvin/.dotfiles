local M = {}

M.setup = function()
	require("tobyvin.options").setup()
	require("tobyvin.autocmds").setup()
	require("tobyvin.keymaps").setup()
	require("tobyvin.plugins").setup()
	require("tobyvin.lsp").setup()
end

return M
