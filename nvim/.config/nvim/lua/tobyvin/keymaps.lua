local utils = require("tobyvin.utils")
local M = {}

M.write = function()
	vim.cmd("write")
end

M.setup = function()
	local nmap = utils.create_map_group("n", "<leader>")
	nmap("q", utils.quit, { desc = "Quit" })
	nmap("c", utils.bdelete, { desc = "Close" })
	nmap("x", utils.tabclose, { desc = "Close" })
	nmap("h", utils.hover, { desc = "Hover" })
	nmap("H", utils.docs, { desc = "Docs" })
	nmap("w", M.write, { desc = "Write" })
end

return M
