local utils = require("tobyvin.utils")
local M = {}

M.with_range = function(callback)
	return function()
		callback(utils.buffer.get_visual_range())
	end
end

M.show_blameline = function()
	require("gitsigns").blame_line({ full = true })
end

M.toggle_blameline = function()
	require("gitsigns").toggle_current_line_blame()
end

M.on_attach = function(bufnr)
	local gitsigns = require("gitsigns")
	utils.keymap.group("n", "<leader>g", { desc = "Git", buffer = bufnr })
	vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, { desc = "Show blame", buffer = bufnr })
	vim.keymap.set("n", "<leader>gB", M.show_blameline, { desc = "Show blame", buffer = bufnr })
	vim.keymap.set("n", "<leader>g<C-b>", M.toggle_blameline, { desc = "Toggle blame", buffer = bufnr })
	vim.keymap.set("n", "<leader>gj", gitsigns.next_hunk, { desc = "Next Hunk", buffer = bufnr })
	vim.keymap.set("n", "<leader>gk", gitsigns.prev_hunk, { desc = "Prev Hunk", buffer = bufnr })

	vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview Hunk", buffer = bufnr })
	vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset Hunk", buffer = bufnr })
	vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage Hunk", buffer = bufnr })
	vim.keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk", buffer = bufnr })

	-- vim.keymap.set("n", "<leader>gP", gitsigns.preview_buffer, { desc = "Preview Buffer", buffer = bufnr })
	vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset Buffer", buffer = bufnr })
	vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage Buffer", buffer = bufnr })
	vim.keymap.set("n", "<leader>gU", gitsigns.reset_buffer_index, { desc = "Undo Stage Buffer", buffer = bufnr })

	utils.keymap.group("v", "<leader>g", { desc = "Git", buffer = bufnr })
	vim.keymap.set("v", "<leader>gp", M.with_range(gitsigns.preview_hunk), { desc = "Preview Hunk", buffer = bufnr })
	vim.keymap.set("v", "<leader>gr", M.with_range(gitsigns.reset_hunk), { desc = "Reset Hunk", buffer = bufnr })
	vim.keymap.set("v", "<leader>gs", M.with_range(gitsigns.stage_hunk), { desc = "Stage Hunk", buffer = bufnr })
	vim.keymap.set("v", "<leader>gu", M.with_range(gitsigns.undo_stage_hunk), { desc = "Unstage Hunk", buffer = bufnr })

	vim.api.nvim_exec_autocmds("User", { pattern = "GitAttach", data = { buf = bufnr } })
end

M.setup = function()
	local status_ok, gitsigns = pcall(require, "gitsigns")
	if not status_ok then
		vim.notify("Failed to load module 'gitsigns'", vim.log.levels.ERROR)
		return
	end

	gitsigns.setup({
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "契" },
			topdelete = { text = "契" },
			changedelete = { text = "▎" },
		},
		preview_config = { border = "rounded" },
		on_attach = M.on_attach,
	})
end

return M
