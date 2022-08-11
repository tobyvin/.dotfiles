local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, neogit = pcall(require, "neogit")
	if not status_ok then
		vim.notify("Failed to load module 'neogit'", "error")
		return
	end

  require("neogit")
	neogit.setup({
		disable_commit_confirmation = true,
		disable_signs = true,
		integrations = {
			diffview = true,
		},
		-- kind = "replace",
	})

	local nmap = utils.create_map_group("n", "<leader>g", { desc = "Git" })
	nmap("g", neogit.open, { desc = "Neogit" })
end

return M
