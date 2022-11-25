local status_ok, comment = pcall(require, "Comment")
if not status_ok then
	vim.notify("Failed to load module 'Comment'", vim.log.levels.ERROR)
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
