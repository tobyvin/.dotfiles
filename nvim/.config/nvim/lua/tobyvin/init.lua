local M = {}

M.setup = function()
	-- load = function(module)
	-- 	package.loaded[module] = nil
	-- 	return require(module)
	-- end

	require("tobyvin.options").setup()
	require("tobyvin.plugins").setup()
	require("tobyvin.lsp").setup()

	-- deferred execution makes the editor feel more responsive
	vim.defer_fn(function()
		require("tobyvin.autocommands")
		require("tobyvin.mappings")
	end, 0)
end

return M
