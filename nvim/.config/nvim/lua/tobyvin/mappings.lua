local utils = require("tobyvin.utils")
local M = {}

M.quit = function()
	vim.cmd("quit")
end

M.quit_force = function()
	vim.cmd("quit!")
end

M.write = function()
	vim.cmd("write")
end

M.write_force = function()
	vim.cmd("write!")
end

M.close = function()
	vim.cmd("bdelete")
end

M.close_force = function()
	vim.cmd("bdelete!")
end

M.setup = function()
	local nmap = utils.create_map_group("n", "<leader>")
	nmap("q", M.quit, { desc = "Quit" })
	nmap("Q", M.quit_force, { desc = "Quit!" })
	nmap("w", M.write, { desc = "Write" })
	nmap("W", M.write_force, { desc = "Write!" })
	nmap("c", M.close, { desc = "Close" })
	nmap("C", M.close_force, { desc = "Close!" })
end

return M
