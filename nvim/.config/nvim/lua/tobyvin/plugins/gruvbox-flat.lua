---@diagnostic disable: undefined-field
local M = {}

M.setup = function()
	vim.opt.background = "dark"
	vim.g.gruvbox_flat_style = "hard"
	vim.g.gruvbox_transparent = true

	local colors = require("gruvbox.colors").setup({})
	local theme = require("gruvbox.theme").setup({})

	vim.g.gruvbox_colors = { bg_statusline = colors.bg_highlight }
	vim.g.gruvbox_theme = {
		debugBreakpoint = { bg = theme.base.SignColumn.bg, fg = "error" },
	}

	vim.cmd([[colorscheme gruvbox-flat]])

	local ns_id = vim.api.nvim_create_namespace("gruvbox")

	-- TODO: figure out why dap/dapui highlights are not being used
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
end

return M
