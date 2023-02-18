---@type LazyPlugin
local M = {
	"folke/noice.nvim",
	version = "*",
	event = { "VeryLazy" },
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	---@type NoiceConfig
	opts = {
		cmdline = { enabled = false },
		messages = { enabled = false },
		popupmenu = {
			backend = "cmp",
		},
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			progress = {
				format = {
					{ "{data.progress.message} " },
					"({data.progress.percentage}%) ",
					{ "{spinner} ", hl_group = "NoiceLspProgressSpinner" },
					{ "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
					{ "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
				},
				format_done = {
					{
						require("tobyvin.utils.status").signs.done.text,
						hl_group = "NoiceLspProgressDone",
					},
					{ "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
					{ "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
				},
			},
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
				view = "notify_send",
				filter = {
					event = "notify",
					cond = function()
						return vim.g.notify_send_enabled
					end,
				},
				opts = { stop = false, app_name = "nvim" },
			},
			{
				view = "mini",
				filter = {
					event = "notify",
					any = {
						{
							error = false,
							warning = false,
							cond = function(message)
								return vim.tbl_get(message, "opts", "title") == "Neogit"
							end,
						},
					},
				},
			},
		},
		views = {
			hover = {
				border = {
					style = "single",
				},
				position = { row = 2, col = 2 },
			},
			mini = {
				position = {
					row = -2,
				},
				win_options = {
					winblend = 0,
				},
			},
		},
	},
}

function M.init()
	vim.keymap.set("n", "<leader>nn", function()
		require("noice").cmd("history")
	end, { desc = "message history" })

	vim.keymap.set("n", "<leader>nl", function()
		require("noice").cmd("last")
	end, { desc = "last message" })

	vim.keymap.set("n", "<leader>ne", function()
		require("noice").cmd("errors")
	end, { desc = "error messages" })

	vim.keymap.set({ "n", "i", "s" }, "<c-d>", function()
		if not require("noice.lsp").scroll(4) then
			return "<C-d>zz"
		end
	end, { desc = "up half page and center", expr = true })

	vim.keymap.set({ "n", "i", "s" }, "<c-u>", function()
		if not require("noice.lsp").scroll(-4) then
			return "<C-u>zz"
		end
	end, { desc = "down half page and center", expr = true })
end

---@param opts NoiceConfig
function M.config(plugin, opts)
	local augroup = vim.api.nvim_create_augroup(plugin.name, {})

	vim.g.notify_send_enabled = false
	vim.api.nvim_create_autocmd("FocusLost", {
		group = augroup,
		callback = function()
			vim.g.notify_send_enabled = true
		end,
		desc = "Enable notify-send",
	})

	vim.api.nvim_create_autocmd("FocusGained", {
		group = augroup,
		callback = function()
			vim.g.notify_send_enabled = false
		end,
		desc = "Disable notify-send",
	})

	vim.api.nvim_set_hl(0, "NoiceLspProgressSpinner", {
		link = require("tobyvin.utils.status").signs.spinner.texthl,
	})

	vim.api.nvim_set_hl(0, "NoiceLspProgressDone", {
		link = require("tobyvin.utils.status").signs.done.texthl,
	})

	require("noice").setup(opts)
end

return M
