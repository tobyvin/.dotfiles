local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, neogit = pcall(require, "neogit")
	if not status_ok then
		vim.notify("Failed to load module 'neogit'", vim.log.levels.ERROR)
		return
	end

	neogit.setup({
		disable_commit_confirmation = true,
		disable_signs = true,
		integrations = {
			diffview = true,
		},
	})

	utils.keymap.group("n", "<leader>g", { desc = "git" })
	vim.keymap.set("n", "<leader>gg", neogit.open, { desc = "neogit" })
end

return M
