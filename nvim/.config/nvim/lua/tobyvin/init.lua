local M = {}

M.setup = function()
	-- load = function(module)
	-- 	package.loaded[module] = nil
	-- 	return require(module)
	-- end

	require("tobyvin.options").setup()
	require("tobyvin.autocmds").setup()
	require("tobyvin.keymaps").setup()
	require("tobyvin.plugins").setup()
	require("tobyvin.lsp").setup()
end

return M
