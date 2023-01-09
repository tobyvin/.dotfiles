local M = {
	"lewis6991/gitsigns.nvim",
	version = "*",
	event = "BufReadPre",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "契" },
			topdelete = { text = "契" },
			changedelete = { text = "▎" },
		},
		preview_config = { border = "single" },
		on_attach = function(bufnr)
			local with_range = function(callback)
				return function()
					callback(function()
						local start_pos = vim.fn.getpos("v")
						local end_pos = vim.fn.getcurpos()
						return { start_pos[2], end_pos[2] }
					end)
				end
			end

			local next_hunk = function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					require("gitsigns").next_hunk()
				end)
				return "<Ignore>"
			end

			local prev_hunk = function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					require("gitsigns").prev_hunk()
				end)
				return "<Ignore>"
			end

			vim.keymap.set("n", "]c", next_hunk, { expr = true, desc = "next hunk", buffer = bufnr })
			vim.keymap.set("n", "[c", prev_hunk, { expr = true, desc = "previous hunk", buffer = bufnr })

			vim.keymap.set("n", "<leader>gb", require("gitsigns").blame_line, { desc = "show blame", buffer = bufnr })

			vim.keymap.set("n", "<leader>gB", function()
				require("gitsigns").blame_line({ full = true })
			end, { desc = "show blame", buffer = bufnr })

			vim.keymap.set("n", "<leader>g<C-b>", require("gitsigns").toggle_current_line_blame, {
				desc = "toggle blame",
				buffer = bufnr,
			})

			vim.keymap.set("n", "<leader>gp", require("gitsigns").preview_hunk, {
				desc = "preview hunk",
				buffer = bufnr,
			})

			vim.keymap.set("n", "<leader>gr", require("gitsigns").reset_hunk, {
				desc = "reset hunk",
				buffer = bufnr,
			})

			vim.keymap.set("n", "<leader>gs", require("gitsigns").stage_hunk, {
				desc = "stage hunk",
				buffer = bufnr,
			})

			vim.keymap.set("n", "<leader>gu", require("gitsigns").undo_stage_hunk, {
				desc = "undo stage hunk",
				buffer = bufnr,
			})

			vim.keymap.set("n", "<leader>gR", require("gitsigns").reset_buffer, {
				desc = "reset buffer",
				buffer = bufnr,
			})

			vim.keymap.set("n", "<leader>gS", require("gitsigns").stage_buffer, {
				desc = "stage buffer",
				buffer = bufnr,
			})

			vim.keymap.set("n", "<leader>gU", require("gitsigns").reset_buffer_index, {
				desc = "undo stage buffer",
				buffer = bufnr,
			})

			vim.keymap.set("v", "<leader>gr", with_range(require("gitsigns").reset_hunk), {
				desc = "reset hunk",
				buffer = bufnr,
			})

			vim.keymap.set("v", "<leader>gs", with_range(require("gitsigns").stage_hunk), {
				desc = "stage hunk",
				buffer = bufnr,
			})

			vim.keymap.set("v", "<leader>gu", with_range(require("gitsigns").undo_stage_hunk), {
				desc = "unstage hunk",
				buffer = bufnr,
			})

			vim.keymap.set("v", "<leader>gp", with_range(require("gitsigns").preview_hunk), {
				desc = "preview hunk",
				buffer = bufnr,
			})

			vim.api.nvim_exec_autocmds("User", { pattern = "GitAttach", data = { buf = bufnr } })
		end,
	},
}

return M
