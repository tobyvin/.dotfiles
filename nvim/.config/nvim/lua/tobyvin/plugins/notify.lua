local M = {}

M.setup = function()
	local status_ok, notify = pcall(require, "notify")
	if not status_ok then
		vim.notify("Failed to load module 'notify'", vim.log.levels.ERROR)
		return
	end

	notify.setup({
		background_colour = "#" .. vim.api.nvim_get_hl_by_name("Pmenu", true).background,
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = "Notify",
		callback = function(args)
			notify.notify(unpack(args.data))
		end,
	})

	local telescope_ok, telescope = pcall(require, "telescope")
	if telescope_ok then
		telescope.load_extension("notify")
		vim.keymap.set("n", "<leader>fn", telescope.extensions.notify.notify, { desc = "notifications" })
	end
end

return M
