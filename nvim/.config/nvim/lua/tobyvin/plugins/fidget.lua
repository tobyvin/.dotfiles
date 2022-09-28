local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, fidget = pcall(require, "fidget")
	if not status_ok then
		vim.notify("Failed to load module 'fidget'", "error")
		return
	end

	fidget.setup({
		text = {
			spinner = utils.status.signs.spinner.text,
			done = vim.trim(utils.status.signs.completed.text),
		},
		window = { blend = 0 },
	})
end

return M
