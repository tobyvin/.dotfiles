local M = {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
	dependencies = { "nvim-lua/plenary.nvim" },
}

function M.config()
	local gitsigns = require("gitsigns")

	local with_range = function(callback)
		return function()
			callback(function()
				local start_pos = vim.fn.getpos("v")
				local end_pos = vim.fn.getcurpos()
				return { start_pos[2], end_pos[2] }
			end)
		end
	end

	local show_blameline = function()
		gitsigns.blame_line({ full = true })
	end

	local toggle_blameline = function()
		gitsigns.toggle_current_line_blame()
	end

	local next_hunk = function()
		if vim.wo.diff then
			return "]c"
		end
		vim.schedule(function()
			gitsigns.next_hunk()
		end)
		return "<Ignore>"
	end

	local prev_hunk = function()
		if vim.wo.diff then
			return "[c"
		end
		vim.schedule(function()
			gitsigns.prev_hunk()
		end)
		return "<Ignore>"
	end

	local on_attach = function(bufnr)
		vim.keymap.set("n", "]c", next_hunk, { expr = true, desc = "next hunk", buffer = bufnr })
		vim.keymap.set("n", "[c", prev_hunk, { expr = true, desc = "previous hunk", buffer = bufnr })

		vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, { desc = "show blame", buffer = bufnr })
		vim.keymap.set("n", "<leader>gB", show_blameline, { desc = "show blame", buffer = bufnr })
		vim.keymap.set("n", "<leader>g<C-b>", toggle_blameline, { desc = "toggle blame", buffer = bufnr })

		vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "preview hunk", buffer = bufnr })
		vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "reset hunk", buffer = bufnr })
		vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { desc = "stage hunk", buffer = bufnr })
		vim.keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "undo stage hunk", buffer = bufnr })

		vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { desc = "reset buffer", buffer = bufnr })
		vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "stage buffer", buffer = bufnr })
		vim.keymap.set("n", "<leader>gU", gitsigns.reset_buffer_index, { desc = "undo stage buffer", buffer = bufnr })

		vim.keymap.set("v", "<leader>gp", with_range(gitsigns.preview_hunk), { desc = "preview hunk", buffer = bufnr })
		vim.keymap.set("v", "<leader>gr", with_range(gitsigns.reset_hunk), { desc = "reset hunk", buffer = bufnr })
		vim.keymap.set("v", "<leader>gs", with_range(gitsigns.stage_hunk), { desc = "stage hunk", buffer = bufnr })
		vim.keymap.set(
			"v",
			"<leader>gu",
			with_range(gitsigns.undo_stage_hunk),
			{ desc = "unstage hunk", buffer = bufnr }
		)

		vim.api.nvim_exec_autocmds("User", { pattern = "GitAttach", data = { buf = bufnr } })
	end

	gitsigns.setup({
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "契" },
			topdelete = { text = "契" },
			changedelete = { text = "▎" },
		},
		preview_config = { border = "single" },
		on_attach = on_attach,
	})
end

return M
