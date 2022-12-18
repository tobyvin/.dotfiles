local status_ok, notify = pcall(require, "notify")
if not status_ok then
	vim.notify("Failed to load module 'notify'", vim.log.levels.ERROR)
	return
end

local global_instance, _ = notify.instance({
	max_width = 100,
	on_open = function(win)
		vim.api.nvim_win_set_option(win, "wrap", true)
	end,
})

vim.notify.use_console = false
vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("tobyvin_nvim-notify", { clear = true }),
	pattern = "Notify",
	callback = function(args)
		global_instance.notify(unpack(args.data))
	end,
})

vim.api.nvim_set_hl(0, "NotifyBackground", { link = "WinBar" })

local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
	telescope.load_extension("notify")
	vim.keymap.set("n", "<leader>fn", telescope.extensions.notify.notify, { desc = "notifications" })
end
