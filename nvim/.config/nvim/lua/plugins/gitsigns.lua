---@type LazyPluginSpec
local M = {
	"lewis6991/gitsigns.nvim",
	version = "*",
	event = "BufReadPre",
	dependencies = { "nvim-lua/plenary.nvim" },
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
			local with_range = function(callback)
				return function()
					if vim.fn.mode():lower() == "v" then
						local cursor = vim.fn.getpos(".") --[[@as integer[] ]]
						local visual = vim.fn.getpos("v") --[[@as integer[] ]]
						callback({ cursor[2], visual[2] })
					else
						callback()
					end
				end
			end

			vim.keymap.set("n", "<leader>gb", require("gitsigns").blame_line, { desc = "show blame", buffer = bufnr })

			vim.keymap.set("n", "]c", function()
				return require("gitsigns").nav_hunk("next", { preview = true })
			end, { expr = true, desc = "next hunk", buffer = bufnr })

			vim.keymap.set("n", "[c", function()
				return require("gitsigns").nav_hunk("prev", { preview = true })
			end, { expr = true, desc = "previous hunk", buffer = bufnr })

			vim.keymap.set("n", "<leader>gB", function()
				require("gitsigns").blame_line({ full = true })
			end, { desc = "show blame", buffer = bufnr })

			vim.keymap.set({ "n", "v" }, "<leader>gr", with_range(require("gitsigns").reset_hunk), {
				desc = "reset hunk",
				buffer = bufnr,
			})

			vim.keymap.set({ "n", "v" }, "<leader>gs", with_range(require("gitsigns").stage_hunk), {
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
}

return M
