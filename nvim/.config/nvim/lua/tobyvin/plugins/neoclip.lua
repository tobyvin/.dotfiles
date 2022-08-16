local M = {}

M.setup = function()
	local status_ok, neoclip = pcall(require, "neoclip")
	if not status_ok then
		vim.notify("Failed to load module 'neoclip'", "error")
		return
	end

	neoclip.setup()

	local telescope = require("telescope")
	telescope.load_extension("neoclip")

	vim.keymap.set("n", "fy", telescope.extensions.neoclip.default, { desc = "Yank History" })
	vim.keymap.set("n", "fM", telescope.extensions.macroscope.default, { desc = "Macro History" })
end

return M
