local M = {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	dependencies = {
		{ "nvim-telescope/telescope.nvim" },
	},
}

function M.config()
	local notify = require("notify")

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

	vim.keymap.set("n", "<leader>fn", function()
		require("telescope").extensions.notify.notify()
	end, { desc = "notifications" })
end

return M
