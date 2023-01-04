local M = {
	"andweeb/presence.nvim",
	event = "VeryLazy",
}

function M.config()
	local Presence = require("presence"):setup({
		enable_line_number = true,
		focus_lost_delay = 60,
	})

	function Presence:handle_focus_lost()
		self:start_idle_timer(self.options.focus_lost_delay, function()
			self:cancel()
		end)
	end

	function Presence:start_idle_timer(timeout, callback)
		local idle_timeout = timeout * 1000
		self.idle_timer = vim.fn.timer_start(idle_timeout, callback)
	end

	function Presence:cancel_idle_timer()
		vim.fn.timer_stop(self.idle_timer)
		self.idle_timer = nil
	end

	vim.api.nvim_create_autocmd("FocusLost", {
		callback = function()
			Presence:handle_focus_lost()
		end,
	})

	vim.api.nvim_create_autocmd("FocusGained", {
		callback = function()
			Presence:cancel_idle_timer()
		end,
	})
end

return M
