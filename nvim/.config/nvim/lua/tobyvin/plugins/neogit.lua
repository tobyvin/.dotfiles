local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, neogit = pcall(require, "neogit")
	if not status_ok then
		vim.notify("Failed to load module 'neogit'", "error")
		return
	end

	neogit.setup({
		disable_commit_confirmation = true,
		disable_signs = true,
		integrations = {
			diffview = true,
		},
	})

	local nmap = utils.create_map_group("n", "<leader>g", "git")
	nmap("g", neogit.open, { desc = "Neogit" })
end

return M
