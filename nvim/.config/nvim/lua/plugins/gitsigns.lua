---@type LazySpec
local M = {
	"nvim-lua/plenary.nvim",
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "󰐊" },
				topdelete = { text = "󰐊" },
				changedelete = { text = "▎" },
			},
			preview_config = { border = "single" },
			on_attach = function(bufnr)
				vim.keymap.set("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					else
						return [[<Cmd>lua require("gitsigns").nav_hunk("next")<CR>]]
					end
				end, { expr = true, desc = "next hunk", buffer = bufnr })

				vim.keymap.set("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					else
						return [[<Cmd>lua require("gitsigns").nav_hunk("prev")<CR>]]
					end
				end, {
					expr = true,
					desc = "previous hunk",
					buffer = bufnr,
				})

				vim.keymap.set("n", "<leader>gr", require("gitsigns").reset_hunk, {
					desc = "reset hunk",
					buffer = bufnr,
				})

				vim.keymap.set("v", "<leader>gr", function()
					require("gitsigns").reset_hunk({ vim.fn.getpos(".")[2], vim.fn.getpos("v")[2] })
				end, {
					desc = "reset hunk",
					buffer = bufnr,
				})

				vim.keymap.set("n", "<leader>gs", require("gitsigns").stage_hunk, {
					desc = "stage hunk",
					buffer = bufnr,
				})

				vim.keymap.set("v", "<leader>gs", function()
					require("gitsigns").stage_hunk({ vim.fn.getpos(".")[2], vim.fn.getpos("v")[2] })
				end, {
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
			end,
		},
	},
}

return M
