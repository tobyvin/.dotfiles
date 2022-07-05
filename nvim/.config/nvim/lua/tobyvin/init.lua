local M = {}

M.setup = function()
	-- load = function(module)
	-- 	package.loaded[module] = nil
	-- 	return require(module)
	-- end

	require("tobyvin.options").setup()
	require("tobyvin.plugins").setup()
	require("tobyvin.lsp").setup()
	require("tobyvin.autocommands").setup()
	require("tobyvin.mappings").setup()
end

return M
