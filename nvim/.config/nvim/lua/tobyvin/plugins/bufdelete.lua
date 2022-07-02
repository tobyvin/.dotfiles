local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, bufdelete = pcall(require, "bufdelete")
	if not status_ok then
		vim.notify("Failed to load module 'bufdelete'", "error")
		return
	end

	local nmap = utils.create_map_group("n", "<leader>")
	-- nmap("c", bufdelete.bufdelete, { desc = "Close buffer" })
	nmap("c", function() vim.cmd("Bdelete") end, { desc = "Close buffer" })
end

return M
