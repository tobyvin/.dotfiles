---@type LazySpec
local M = {
	"andweeb/presence.nvim",
	event = "UIEnter",
}

function M:config(opts)
	require("presence").setup(opts)

	vim.api.nvim_create_autocmd("SessionLoadPost", {
		callback = function()
			require("presence"):handle_win_enter()
		end,
	})

	vim.api.nvim_create_autocmd("FocusLost", {
		group = vim.api.nvim_create_augroup("user.presence", { clear = true }),
		callback = function()
			local idle_timer = vim.defer_fn(function()
				require("presence").log:debug("Idle timeout reached...")
				require("presence"):cancel()
				require("presence").last_activity.file = nil
			end, 300000)

			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					idle_timer:stop()
					return true
				end,
			})
		end,
		desc = "start presence idle timer",
	})
end

return M
