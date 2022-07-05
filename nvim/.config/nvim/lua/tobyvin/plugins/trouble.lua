local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, trouble = pcall(require, "trouble")
	if not status_ok then
		vim.notify("Failed to load module 'trouble'", "error")
		return
	end

	trouble.setup({
		-- signs = {
		-- 	error = utils.diagnostic_signs.error.text,
		-- 	warning = utils.diagnostic_signs.warn.text,
		-- 	hint = utils.diagnostic_signs.hint.text,
		-- 	information = utils.diagnostic_signs.info.text,
		-- 	other = utils.diagnostic_signs.info.text,
		-- },
		use_diagnostic_signs = true,
	})
end

return M
