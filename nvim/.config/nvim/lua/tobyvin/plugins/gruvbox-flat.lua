---@diagnostic disable: undefined-field
local M = {}

M.setup = function()
	vim.opt.background = "dark"
	vim.g.gruvbox_flat_style = "hard"

	local colors = require("gruvbox.colors").setup({})
	local theme = require("gruvbox.theme").setup({})

	vim.g.gruvbox_colors = { bg_statusline = "none" }
	vim.g.gruvbox_theme = {
		debugBreakpoint = { bg = theme.base.SignColumn.bg, fg = "error" },
	}

	vim.cmd([[colorscheme gruvbox-flat]])

	local ns_id = vim.api.nvim_create_namespace("gruvbox")

	-- TODO: figure out why these highlights are not being used
	-- Transparent
	vim.api.nvim_set_hl(ns_id, "NormalFloat", { fg = colors.fg, bg = colors.bg_float, sp = "none" })
	vim.api.nvim_set_hl(ns_id, "SignColumn", { fg = colors.fg_gutter, bg = colors.bg, sp = "none" })
	vim.api.nvim_set_hl(ns_id, "Normal", { fg = colors.fg, bg = colors.bg, sp = "none" })
	vim.api.nvim_set_hl(ns_id, "NormalNC", { fg = colors.fg, bg = colors.bg, sp = "none" })

	-- nvim-dap
	vim.api.nvim_set_hl(ns_id, "DapBreakpoint", { link = "debugBreakpoint" })
	vim.api.nvim_set_hl(ns_id, "DapStopped", { link = "debugPC" })

	-- nvim-dap-ui
	vim.api.nvim_set_hl(ns_id, "DapUIVariable", { link = "TSVariable" })
	vim.api.nvim_set_hl(ns_id, "DapUIScope", { link = "TSNamespace" })
	vim.api.nvim_set_hl(ns_id, "DapUIType", { link = "Type" })
	vim.api.nvim_set_hl(ns_id, "DapUIModifiedValue", { link = "Keyword" })
	vim.api.nvim_set_hl(ns_id, "DapUIDecoration", { link = "PreProc" })
	vim.api.nvim_set_hl(ns_id, "DapUIThread", { link = "String" })
	vim.api.nvim_set_hl(ns_id, "DapUIStoppedThread", { link = "Special" })
	vim.api.nvim_set_hl(ns_id, "DapUIFrameName", { link = "Normal" })
	vim.api.nvim_set_hl(ns_id, "DapUISource", { link = "TSKeyword" })
	vim.api.nvim_set_hl(ns_id, "DapUILineNumber", { link = "TSOperator" })
	vim.api.nvim_set_hl(ns_id, "DapUIFloatBorder", { link = "FloatBorder" })
	vim.api.nvim_set_hl(ns_id, "DapUIWatchesEmpty", { link = "LspDiagnosticsError" })
	vim.api.nvim_set_hl(ns_id, "DapUIWatchesValue", { link = "String" })
	vim.api.nvim_set_hl(ns_id, "DapUIWatchesError", { link = "LspDiagnosticsError" })
	vim.api.nvim_set_hl(ns_id, "DapUIBreakpointsPath", { link = "Keyword" })
	vim.api.nvim_set_hl(ns_id, "DapUIBreakpointsInfo", { link = "LspDiagnosticsInfo" })
	vim.api.nvim_set_hl(ns_id, "DapUIBreakpointsCurrentLine", { link = "DapStopped" })
	vim.api.nvim_set_hl(ns_id, "DapUIBreakpointsLine", { link = "DapUILineNumber" })

	require("transparent").setup({
		enable = true,
	})
end

return M
