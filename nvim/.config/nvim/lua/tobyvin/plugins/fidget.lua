local status_ok, fidget = pcall(require, "fidget")
if not status_ok then
	vim.notify("Failed to load module 'fidget'", vim.log.levels.ERROR)
	return
end

local utils = require("tobyvin.utils")

fidget.setup({
	text = {
		spinner = utils.status.signs.spinner.text,
		done = vim.trim(utils.status.signs.completed.text),
	},
	window = { blend = 0 },
})
