local utils = require("tobyvin.utils")
local M = {
	dapui_win = nil,
	dapui_tab = nil,
}

M.eval = function()
	vim.ui.input({ prompt = "Expr: " }, function(input)
		require("dapui").eval(input, {})
	end)
end

M.open = function()
	if M.dapui_win and vim.api.nvim_win_is_valid(M.dapui_win) then
		vim.api.nvim_set_current_win(M.dapui_win)
		return
	end

	local dap = require("dap")
	local dapui = require("dapui")

	vim.cmd("tabedit %")
	M.dapui_win = vim.fn.win_getid()
	M.dapui_tab = vim.api.nvim_win_get_tabpage(M.dapui_win)

	dapui.open({})

	vim.keymap.set("n", "<leader>q", dap.terminate, { desc = "Quit (DAP)" })

	vim.api.nvim_create_autocmd("TabClosed", {
		group = vim.api.nvim_create_augroup("DapAU", { clear = true }),
		callback = function()
			dap.terminate()
			return true
		end,
	})
end

M.close = function()
	local dapui = require("dapui")

	dapui.close({})

	vim.keymap.set("n", "<leader>q", utils.buffer.quit, { desc = "Quit" })

	if M.dapui_tab and vim.api.nvim_tabpage_is_valid(M.dapui_tab) then
		local tabnr = vim.api.nvim_tabpage_get_number(M.dapui_tab)
		vim.cmd("tabclose " .. tabnr)
	end

	M.dapui_win = nil
	M.dapui_tab = nil
end

M.setup = function()
	local status_ok, dapui = pcall(require, "dapui")
	if not status_ok then
		vim.notify("Failed to load module 'dapui'", vim.log.levels.ERROR)
		return
	end

	local dap = require("dap")

	vim.keymap.set("n", "<leader>de", M.eval, { desc = "Eval" })
	vim.keymap.set("n", "<leader>du", dapui.open, { desc = "DapUI" })

	-- Attach DAP UI to DAP events
	dap.listeners.before.event_terminated["dapui_config"] = M.close
	dap.listeners.before.event_exited["dapui_config"] = M.close
	dap.listeners.before.disconnect["dapui_config"] = M.close

	vim.api.nvim_set_hl(0, "DapUIVariable", { link = "TSVariable" })
	vim.api.nvim_set_hl(0, "DapUIScope", { link = "TSNamespace" })
	vim.api.nvim_set_hl(0, "DapUIType", { link = "Type" })
	vim.api.nvim_set_hl(0, "DapUIModifiedValue", { link = "Keyword" })
	vim.api.nvim_set_hl(0, "DapUIDecoration", { link = "PreProc" })
	vim.api.nvim_set_hl(0, "DapUIThread", { link = "String" })
	vim.api.nvim_set_hl(0, "DapUIStoppedThread", { link = "Special" })
	vim.api.nvim_set_hl(0, "DapUIFrameName", { link = "Normal" })
	vim.api.nvim_set_hl(0, "DapUISource", { link = "TSKeyword" })
	vim.api.nvim_set_hl(0, "DapUILineNumber", { link = "TSOperator" })
	vim.api.nvim_set_hl(0, "DapUIFloatBorder", { link = "FloatBorder" })
	vim.api.nvim_set_hl(0, "DapUIWatchesEmpty", { link = "LspDiagnosticsError" })
	vim.api.nvim_set_hl(0, "DapUIWatchesValue", { link = "String" })
	vim.api.nvim_set_hl(0, "DapUIWatchesError", { link = "LspDiagnosticsError" })
	vim.api.nvim_set_hl(0, "DapUIBreakpointsPath", { link = "Keyword" })
	vim.api.nvim_set_hl(0, "DapUIBreakpointsInfo", { link = "LspDiagnosticsInfo" })
	vim.api.nvim_set_hl(0, "DapUIBreakpointsCurrentLine", { link = "DapStopped" })
	vim.api.nvim_set_hl(0, "DapUIBreakpointsLine", { link = "DapUILineNumber" })
end

return M
