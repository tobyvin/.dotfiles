local status_ok, bqf = pcall(require, "bqf")
if not status_ok then
	vim.notify("Failed to load module 'bqf'", vim.log.levels.ERROR)
	return
end

bqf.setup({
	auto_resize_height = true,
	preview = {
		border_chars = { "│", "│", "─", "─", "┌", "┐", "└", "┘", "█" },
	},
	func_map = {
		open = "o",
		openc = "<cr>",
		tabc = "t",
		tab = "<C-t>",
		pscrollup = "<C-u>",
		pscrolldown = "<C-d>",
	},
})
