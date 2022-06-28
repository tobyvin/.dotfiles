local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, refactoring = pcall(require, "refactoring")
	if not status_ok then
		vim.notify("Failed to load module 'refactoring'", "error")
		return
	end

	refactoring.setup()

	local nmap = utils.create_map_group("n", "<leader>r", "Refactor")
	nmap("b", function()
		refactoring.refactor("Extract Block")
	end, { desc = "Extract Block" })
	nmap("B", function()
		refactoring.refactor("Extract Block To File")
	end, { desc = "Extract Block To File" })
	nmap("i", function()
		refactoring.refactor("Inline Variable")
	end, { desc = "Inline Variable" })

	local vmap = utils.create_map_group("v", "<leader>r", "Refactor")
	vmap("e", function()
		refactoring.refactor("Extract Function")
	end, { desc = "Extract Function" })
	vmap("f", function()
		refactoring.refactor("Extract Function To File")
	end, { desc = "Extract Function To File" })
	vmap("v", function()
		refactoring.refactor("Extract Variable")
	end, { desc = "Extract Variable" })
	vmap("i", function()
		refactoring.refactor("Inline Variable")
	end, { desc = "Inline Variable" })
end

return M
