local focused = true

local M = {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = {
		cmdline = { enabled = false },
		messages = { enabled = false },
		popupmenu = { enabled = false },
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			progress = { enabled = false },
			-- hover = { enabled = false },
			-- signature = { enabled = false },
			messages = { enabled = false },
		},
		commands = {
			all = {
				view = "split",
				opts = { enter = true, format = "details" },
				filter = {},
			},
		},
		routes = {
			{
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			},
		},
	},
}

function M.init()
	vim.api.nvim_create_autocmd("FocusGained", {
		callback = function()
			focused = true
		end,
	})

	vim.api.nvim_create_autocmd("FocusLost", {
		callback = function()
			focused = false
		end,
	})

	vim.keymap.set("n", "<leader>nl", function()
		require("noice").cmd("last")
	end)

	vim.keymap.set("n", "<leader>nn", function()
		require("noice").cmd("history")
	end)

	vim.keymap.set("n", "<leader>nh", function()
		require("noice").cmd("all")
	end)

	vim.keymap.set("n", "<C-d>", function()
		if not require("noice.lsp").scroll(4) then
			return "<C-d>"
		end
	end, { expr = true })

	vim.keymap.set("n", "<C-u>", function()
		if not require("noice.lsp").scroll(-4) then
			return "<C-u>"
		end
	end, { expr = true })

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "markdown",
		callback = function(event)
			vim.schedule(function()
				require("noice.text.markdown").keys(event.buf)
			end)
		end,
	})
end

return M
