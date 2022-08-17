local utils = require("tobyvin.utils")
local M = {
	dapui_win = nil,
	dapui_tab = nil,
}

M.highlights = function()
	local ns_id = 0
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

M.set_custom_breakpoint = function()
	vim.ui.input({ prompt = "Condition: " }, function(condition)
		vim.ui.input({ prompt = "Hit condition: " }, function(hit_condition)
			vim.ui.input({ prompt = "Log point message: " }, function(log_message)
				require("dap").set_breakpoint(condition, hit_condition, log_message)
			end)
		end)
	end)
end

M.eval = function()
	vim.ui.input({ prompt = "Expr: " }, function(input)
		require("dapui").eval(input, {})
	end)
end

M.dapui_open = function()
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

	local on_tab_closed = function()
		dap.terminate()
		return true
	end

	local group = vim.api.nvim_create_augroup("DapAU", { clear = true })
	vim.api.nvim_create_autocmd("TabClosed", { group = group, callback = on_tab_closed })
end

M.dapui_close = function()
	local dapui = require("dapui")

	dapui.close({})

	vim.keymap.set("n", "<leader>q", utils.quit, { desc = "Quit" })

	if M.dapui_tab and vim.api.nvim_tabpage_is_valid(M.dapui_tab) then
		local tabnr = vim.api.nvim_tabpage_get_number(M.dapui_tab)
		vim.cmd("tabclose " .. tabnr)
	end

	M.dapui_win = nil
	M.dapui_tab = nil
end

M.progress_start = function(session, body)
	local notif_data = utils.get_notif_data("dap", body.progressId)

	local message = utils.format_message(body.message, body.percentage)
	notif_data.notification = vim.notify(message, "info", {
		title = utils.format_title(body.title, session.config.type),
		icon = utils.signs.spinner.text[1],
		timeout = false,
		hide_from_history = false,
	})

	---@diagnostic disable-next-line: redundant-value
	notif_data.notification.spinner = 1, utils.update_spinner("dap", body.progressId)
end

M.progress_update = function(_, body)
	local notif_data = utils.get_notif_data("dap", body.progressId)
	notif_data.notification = vim.notify(utils.format_message(body.message, body.percentage), "info", {
		replace = notif_data.notification,
		hide_from_history = false,
	})
end

M.progress_end = function(_, body)
	local notif_data = utils.client_notifs["dap"][body.progressId]
	notif_data.notification = vim.notify(body.message and utils.format_message(body.message) or "Complete", "info", {
		icon = utils.signs.complete.text,
		replace = notif_data.notification,
		timeout = 3000,
	})
	notif_data.spinner = nil
end

M.setup = function()
	local status_ok, dap = pcall(require, "dap")
	if not status_ok then
		vim.notify("Failed to load module 'dap'", "error")
		return
	end

	-- TODO: Break these configs out into seperate module, similar to my LSP configs
	-- Debugpy
	dap.adapters.python = {
		type = "executable",
		command = "python",
		args = { "-m", "debugpy.adapter" },
	}

	dap.configurations.python = {
		{
			type = "python",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			pythonPath = function()
				local venv_path = vim.fn.getenv("VIRTUAL_ENVIRONMENT")
				if venv_path ~= vim.NIL and venv_path ~= "" then
					return venv_path .. "/bin/python"
				else
					return "/usr/bin/python"
				end
			end,
		},
	}

	-- Neovim Lua
	dap.adapters.nlua = function(callback, config)
		callback({ type = "server", host = config.host, port = config.port })
	end

	dap.configurations.lua = {
		{
			type = "nlua",
			request = "attach",
			name = "Attach to running Neovim instance",
			host = function()
				local value = vim.fn.input("Host [127.0.0.1]: ")
				if value ~= "" then
					return value
				end
				return "127.0.0.1"
			end,
			port = function()
				local val = tonumber(vim.fn.input("Port: "))
				assert(val, "Please provide a port number")
				return val
			end,
		},
	}

	-- lldb
	dap.adapters.lldb = {
		type = "executable",
		command = "/usr/bin/lldb-vscode",
		name = "lldb",
	}

	dap.configurations.cpp = {
		{
			name = "Launch",
			type = "lldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
			runInTerminal = false,
		},
	}

	dap.configurations.c = dap.configurations.cpp

	-- Disabled in favor of rust-tools
	-- TODO: integrate rust-tools.nvim into this config
	-- dap.configurations.rust = dap.configurations.cpp

	-- Language specific plugins
	require("dap-go").setup()

	-- Virtual text
	require("nvim-dap-virtual-text").setup({})

	-- DAPUI
	require("dapui").setup()

	-- Progress handlers
	dap.listeners.before.event_progressStart["progress-notifications"] = M.progress_start
	dap.listeners.before.event_progressUpdate["progress-notifications"] = M.progress_update
	dap.listeners.before.event_progressEnd["progress-notifications"] = M.progress_end

	-- Delete repl buffer
	dap.listeners.before.event_terminated["close_repl"] = dap.repl.close
	dap.listeners.before.event_exited["close_repl"] = dap.repl.close

	-- Attach DAP UI to DAP events
	dap.listeners.after.event_initialized["dapui_config"] = M.dapui_open
	dap.listeners.before.event_terminated["dapui_config"] = M.dapui_close
	dap.listeners.before.event_exited["dapui_config"] = M.dapui_close
	dap.listeners.before.disconnect["dapui_config"] = M.dapui_close

	-- Telescope
	require("telescope").load_extension("dap")

	-- Keymaps
	vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
	vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
	vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
	vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })

	local nmap = utils.create_map_group("n", "<leader>d", { desc = "Debug" })
	nmap("d", require("telescope").extensions.dap.configurations, { desc = "Configurations" })
	nmap("c", dap.continue, { desc = "Continue" })
	nmap("a", dap.step_over, { desc = "Step Over" })
	nmap("i", dap.step_into, { desc = "Step Into" })
	nmap("o", dap.step_out, { desc = "Step Out" })
	nmap("q", dap.terminate, { desc = "Terminate" })

	nmap("b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
	nmap("B", M.set_custom_breakpoint, { desc = "Custom Breakpoint" })

	nmap("C", require("telescope").extensions.dap.commands, { desc = "Commands" })
	nmap("l", require("telescope").extensions.dap.list_breakpoints, { desc = "List Breakpoints" })
	nmap("v", require("telescope").extensions.dap.variables, { desc = "Variables" })
	nmap("f", require("telescope").extensions.dap.frames, { desc = "Frames" })

	nmap("e", M.eval, { desc = "Eval" })

	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = M.highlights,
	})

	-- Signs
	vim.fn.sign_define("DapBreakpoint", utils.debug_signs.breakpoint)
	vim.fn.sign_define("DapBreakpointCondition", utils.debug_signs.condition)
	vim.fn.sign_define("DapBreakpointRejected", utils.debug_signs.rejected)
	vim.fn.sign_define("DapStopped", utils.debug_signs.stopped)
	vim.fn.sign_define("DapLogPoint", utils.debug_signs.logpoint)
end

return M
