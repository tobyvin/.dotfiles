local utils = require("tobyvin.utils")
local M = {}

M.with_selection = function(callback)
	return function()
		callback(utils.buffer.get_visual_range())
	end
end

M.show_blameline = function()
	require("gitsigns").blame_line({ full = true })
end

M.on_attach = function(bufnr)
	local gitsigns = require("gitsigns")
	local nmap = utils.keymap.group("n", "<leader>g", { desc = "Git", buffer = bufnr })
	nmap("b", gitsigns.blame_line, { desc = "Show blame" })
	nmap("B", M.show_blameline, { desc = "Show blame" })
	nmap("<C-b>", gitsigns.toggle_current_line_blame, { desc = "Toggle blame line" })
	nmap("j", gitsigns.next_hunk, { desc = "Next Hunk" })
	nmap("k", gitsigns.prev_hunk, { desc = "Prev Hunk" })

	nmap("p", gitsigns.preview_hunk, { desc = "Preview Hunk" })
	nmap("r", gitsigns.reset_hunk, { desc = "Reset Hunk" })
	nmap("s", gitsigns.stage_hunk, { desc = "Stage Hunk" })
	nmap("u", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })

	-- nmap("P", gitsigns.preview_buffer, { desc = "Preview Buffer" })
	nmap("R", gitsigns.reset_buffer, { desc = "Reset Buffer" })
	nmap("S", gitsigns.stage_buffer, { desc = "Stage Buffer" })
	nmap("U", gitsigns.reset_buffer_index, { desc = "Undo Stage Buffer" })

	local vmap = utils.keymap.group("v", "<leader>g", { desc = "Git", buffer = bufnr })
	vmap("p", M.with_selection(gitsigns.preview_hunk), { desc = "Preview Hunk" })
	vmap("r", M.with_selection(gitsigns.reset_hunk), { desc = "Reset Hunk" })
	vmap("s", M.with_selection(gitsigns.stage_hunk), { desc = "Stage Hunk" })
	vmap("u", M.with_selection(gitsigns.undo_stage_hunk), { desc = "Undo Stage Hunk" })
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
