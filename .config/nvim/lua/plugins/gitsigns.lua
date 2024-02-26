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

			local next_hunk = function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					require("gitsigns").next_hunk({ preview = true })
				end)
				return "<Ignore>"
			end

			local prev_hunk = function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					require("gitsigns").prev_hunk({ preview = true })
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

			vim.keymap.set({ "n", "v" }, "<leader>gr", with_range(require("gitsigns").reset_hunk), {
				desc = "reset hunk",
				buffer = bufnr,
			})

			vim.keymap.set({ "n", "v" }, "<leader>gs", with_range(require("gitsigns").stage_hunk), {
				desc = "stage hunk",
				buffer = bufnr,
			})

			vim.keymap.set({ "n", "v" }, "<leader>gp", with_range(require("gitsigns").preview_hunk), {
				desc = "preview hunk",
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

			vim.api.nvim_exec_autocmds("User", { pattern = "GitAttach", data = { buf = bufnr } })
		end,
	},
}

function M:config(opts)
	local popup = require("gitsigns.popup")
	local popup_create = popup.create

	---@diagnostic disable-next-line: duplicate-set-field
	function popup.create(...)
		local winid, bufnr = popup_create(...)

		vim.keymap.set("n", "q", function()
			pcall(vim.api.nvim_win_close, winid, true)
		end, { buffer = bufnr })

		return winid, bufnr
	end

	require("gitsigns").setup(opts)
end

return M
