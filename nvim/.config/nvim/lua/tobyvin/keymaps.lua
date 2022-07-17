local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local nmap = utils.create_map_group("n", "<leader>")
	nmap("q", utils.quit, { desc = "quit" })
	nmap("c", utils.bdelete, { desc = "close" })
	nmap("w", function()
		vim.cmd("write")
	end, { desc = "write" })
end

return M
