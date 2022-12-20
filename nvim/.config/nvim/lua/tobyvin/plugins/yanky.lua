local M = {
	"gbprod/yanky.nvim",
}

function M.config()
	local yanky = require("yanky")

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
end

return M
