---@type LazyPluginSpec
local M = {
	"folke/noice.nvim",
	version = "*",
	event = { "LspAttach" },
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		cmdline = { enabled = false },
		messages = { enabled = false },
		popupmenu = { backend = "cmp" },
		lsp = {
			progress = {
				format = {
					{ "{data.progress.message} " },
					"({data.progress.percentage}%) ",
					{ "{spinner} ", hl_group = "NoiceLspProgressSpinner" },
					{ "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
					{ "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
				},
				format_done = {
					{ " ", hl_group = "NoiceLspProgressDone" },
					{ "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
					{ "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
				},
			},
		},
		views = {
			hover = {
				border = { style = "single" },
				position = { row = 2, col = 2 },
			},
			mini = {
				position = { row = -2 },
				win_options = { winblend = 0 },
			},
		},
	},
}

function M:init()
	---@diagnostic disable-next-line: duplicate-set-field
	vim.notify = function(...)
		return require("noice").notify(...)
	end

	vim.api.nvim_set_hl(0, "NoiceLspProgressSpinner", { link = "DiagnosticSignInfo" })
	vim.api.nvim_set_hl(0, "NoiceLspProgressDone", { link = "DiagnosticSignOk" })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("noice-lsp", { clear = true }),
		callback = function(args)
			vim.keymap.set({ "n", "i", "s" }, "<c-d>", function()
				return require("noice.lsp").scroll(4) and "<Ignore>" or "<c-d>"
			end, { expr = true, buffer = args.buf, desc = "up half page" })

			vim.keymap.set({ "n", "i", "s" }, "<c-u>", function()
				return require("noice.lsp").scroll(-4) and "<Ignore>" or "<c-u>"
			end, { expr = true, buffer = args.buf, desc = "down half page" })
		end,
		desc = "setup noice documentation scroll",
	})
end

return M
