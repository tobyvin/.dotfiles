local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
  -- TODO: fix or find a better option, also appeared to have a high load time when running packer profile
	-- local status_ok, refactoring = pcall(require, "refactoring")
	-- if not status_ok then
	-- 	vim.notify("Failed to load module 'refactoring'", "error")
	-- 	return
	-- end
 --
	-- refactoring.setup()
 --
	-- local nmap = utils.keymap.group("n", "<leader>r", { desc = "Refactor" })
	-- nmap("b", function()
	-- 	refactoring.refactor("Extract Block")
	-- end, { desc = "Extract Block" })
	-- nmap("B", function()
	-- 	refactoring.refactor("Extract Block To File")
	-- end, { desc = "Extract Block To File" })
	-- nmap("i", function()
	-- 	refactoring.refactor("Inline Variable")
	-- end, { desc = "Inline Variable" })
 --
 --  -- TODO: Fix needing to exit visual mode
	-- local vmap = utils.keymap.group("v", "<leader>r", { desc = "Refactor" })
	-- vmap("e", function()
	-- 	refactoring.refactor("Extract Function")
	-- end, { desc = "Extract Function" })
	-- vmap("f", function()
	-- 	refactoring.refactor("Extract Function To File")
	-- end, { desc = "Extract Function To File" })
	-- vmap("v", function()
	-- 	refactoring.refactor("Extract Variable")
	-- end, { desc = "Extract Variable" })
	-- vmap("i", function()
	-- 	refactoring.refactor("Inline Variable")
	-- end, { desc = "Inline Variable" })
end

return M
