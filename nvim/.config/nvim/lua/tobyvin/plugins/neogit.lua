local M = {
	"TimUntersberger/neogit",
	dependencies = { "sindrets/diffview.nvim" },
	config = {
		disable_commit_confirmation = true,
		disable_signs = true,
		integrations = {
			diffview = true,
		},
	},
}

function M.init()
	vim.keymap.set("n", "<leader>gg", function()
		require("neogit").open()
	end, { desc = "neogit" })
end

return M
