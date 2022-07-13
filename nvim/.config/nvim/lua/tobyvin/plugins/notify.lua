local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, notify = pcall(require, "notify")
	if not status_ok then
		vim.notify("Failed to load module 'notify'", "error")
		return
	end

	notify.setup({
		background_colour = "#" .. vim.api.nvim_get_hl_by_name("Pmenu", "rgb").background,
	})

	vim.notify = notify

	local telescope_ok, telescope = pcall(require, "telescope")
	if telescope_ok then
		telescope.load_extension("notify")
		local nmap = utils.create_map_group("n", "<leader>f", { name = "Find" })
		nmap("n", telescope.extensions.notify.notify, { desc = "Notifications" })
	end
end

return M
