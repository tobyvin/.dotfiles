local M = {}

M.setup = function()
	local status_ok, gitsigns = pcall(require, "gitsigns")
	if not status_ok then
		vim.notify("Failed to load module 'gitsigns'", "error")
		return
	end

	local nmap = require("tobyvin.utils").create_map_group("n", "<leader>g", { name = "Git" })

	gitsigns.setup({
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "契" },
			topdelete = { text = "契" },
			changedelete = { text = "▎" },
		},
		current_line_blame = true,
		preview_config = { border = "rounded" },
		on_attach = function()
			nmap("j", gitsigns.next_hunk, { desc = "Next Hunk" })
			nmap("k", gitsigns.prev_hunk, { desc = "Prev Hunk" })
			nmap("p", gitsigns.preview_hunk, { desc = "Preview Hunk" })
			nmap("r", gitsigns.reset_hunk, { desc = "Reset Hunk" })
			nmap("R", gitsigns.reset_buffer, { desc = "Reset Buffer" })
			nmap("s", gitsigns.stage_hunk, { desc = "Stage Hunk" })
			nmap("u", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })
		end,
	})
end

return M
