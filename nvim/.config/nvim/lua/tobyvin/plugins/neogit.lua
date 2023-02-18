---@diagnostic disable: duplicate-set-field
local M = {
	"TimUntersberger/neogit",
	opts = {
		console_timeout = 20000,
		auto_show_console = false,
		disable_context_highlighting = true,
		disable_commit_confirmation = true,
		disable_builtin_notifications = true,
		disable_signs = true,
		disable_hint = true,
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
		desc = "Neogit filetype fix",
	})
end

function M.config(_, opts)
	local Buffer = require("neogit.lib.buffer")

	local buffer_show = Buffer.show
	function Buffer:show()
		self.window = buffer_show(self)
		return self.window
	end

	local buffer_close = Buffer.close
	function Buffer:close(force)
		buffer_close(self, force)
		pcall(vim.api.nvim_win_close, self.window, force)
	end

	require("neogit").setup(opts)
end

return M
