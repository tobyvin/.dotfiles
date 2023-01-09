local M = {
	"TimUntersberger/neogit",
	dependencies = { "sindrets/diffview.nvim" },
	opts = {
		auto_show_console = false,
		disable_context_highlighting = true,
		disable_commit_confirmation = true,
		disable_builtin_notifications = true,
		disable_signs = true,
		disable_hint = true,
		integrations = {
			diffview = true,
		},
		mappings = {
			status = {
				["b"] = "",
			},
		},
	},
}

function M.init()
	vim.keymap.set("n", "<leader>gg", function()
		require("neogit").open()
	end, { desc = "neogit" })

	vim.api.nvim_set_hl(0, "NeogitHunkHeaderHighlight", { link = "Comment" })
	vim.api.nvim_set_hl(0, "NeogitHunkHeader", { link = "Comment" })

	-- TODO: revert once #415 is merged
	--
	-- Refs: https://github.com/TimUntersberger/neogit/pull/415
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("neogit_ft_fix", { clear = true }),
		pattern = "NeogitCommitMessage",
		callback = function()
			vim.bo.filetype = "gitcommit"
		end,
		desc = "Vertical help window",
	})
end

return M
