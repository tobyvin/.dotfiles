local M = {
	"gbprod/yanky.nvim",
	event = "TextYankPost",
}

function M.init()
	vim.keymap.set({ "n", "x" }, "<C-p>", function()
		require("yanky.picker").select_in_history()
	end, { desc = "yank history" })
end

function M.config()
	local yanky = require("yanky")

	yanky.setup({
		highlight = {
			on_put = false,
			on_yank = false,
		},
		picker = {
			select = {
				action = require("yanky.picker").actions.set_register(require("yanky.utils").get_default_register()), -- nil to use default put action
			},
		},
		preserve_cursor_position = {
			enabled = false,
		},
	})

	yanky.init_history()
end

return M
