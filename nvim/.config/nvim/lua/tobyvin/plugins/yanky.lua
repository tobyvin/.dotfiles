local status_ok, yanky = pcall(require, "yanky")
if not status_ok then
	vim.notify("Failed to load module 'yanky'", vim.log.levels.ERROR)
	return
end

yanky.setup({
	highlight = {
		on_put = false,
		on_yank = false,
	},
	preserve_cursor_position = {
		enabled = false,
	},
})

local picker = require("yanky.picker")
picker.setup()
vim.keymap.set({ "n", "x" }, "<C-p>", picker.select_in_history, { desc = "yank history" })
