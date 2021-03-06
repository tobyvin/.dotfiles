local M = {}

M.setup = function()
	local status_ok, comment = pcall(require, "Comment")
	if not status_ok then
		vim.notify("Failed to load module 'Comment'", "error")
		return
	end

	comment.setup({
		toggler = {
			block = "gCc",
		},
		opleader = {
			block = "gC",
		},
	})
end

return M
