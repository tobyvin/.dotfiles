local M = {
	"TimUntersberger/neogit",
	dependencies = { "sindrets/diffview.nvim" },
}

function M.config()
	local neogit = require("neogit")

	neogit.setup({
		disable_commit_confirmation = true,
		disable_signs = true,
		integrations = {
			diffview = true,
		},
	})

	vim.keymap.set("n", "<leader>gg", neogit.open, { desc = "neogit" })
end

return M
