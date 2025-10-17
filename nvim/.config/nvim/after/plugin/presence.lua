local success, presence = pcall(require, "presence")
if not success then
	return
end

vim.api.nvim_create_autocmd("SessionLoadPost", {
	callback = function()
		presence:handle_win_enter()
	end,
})

vim.api.nvim_create_autocmd("FocusLost", {
	group = vim.api.nvim_create_augroup("user.presence", { clear = true }),
	callback = function()
		local idle_timer = vim.defer_fn(function()
			presence.log:debug("Idle timeout reached...")
			presence:cancel()
			presence.last_activity.file = nil
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
