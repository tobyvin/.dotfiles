local M = {}

M.setup = function()
	local status_ok, nvim_navic = pcall(require, "nvim-navic")
	if not status_ok then
		vim.notify("Failed to load module 'nvim-navic'", "error")
		return
	end

	nvim_navic.setup({
		icons = require("lspkind").symbol_map,
	})
end

return M
