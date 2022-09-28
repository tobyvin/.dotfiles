local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, trouble = pcall(require, "trouble")
	if not status_ok then
		vim.notify("Failed to load module 'trouble'", "error")
		return
	end

	trouble.setup({
		use_diagnostic_signs = true,
	})
end

return M
