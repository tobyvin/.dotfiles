---@type LazyPluginSpec
local M = {
	"folke/noice.nvim",
	version = "*",
	event = { "VeryLazy" },
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = true,
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
						" ",
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
	vim.api.nvim_set_hl(0, "NoiceLspProgressSpinner", {
		link = "DiagnosticSignInfo",
	})

	vim.api.nvim_set_hl(0, "NoiceLspProgressDone", {
		link = "DiffAdd",
	})

	vim.keymap.set({ "n", "i", "s" }, "<c-d>", function()
		if not require("noice.lsp").scroll(4) then
			return "<c-d>"
		end
	end, { desc = "up half page", expr = true })

	vim.keymap.set({ "n", "i", "s" }, "<c-u>", function()
		if not require("noice.lsp").scroll(-4) then
			return "<c-u>"
		end
	end, { desc = "down half page", expr = true })
end

return M
