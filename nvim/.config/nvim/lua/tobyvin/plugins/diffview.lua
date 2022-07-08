local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, diffview = pcall(require, "diffview")
	if not status_ok then
		vim.notify("Failed to load module 'diffview'", "error")
		return
	end

	diffview.setup()

	local nmap = utils.create_map_group("n", "<leader>g", "Git")
	nmap("d", diffview.open, { desc = "Diffview" })
end

return M
