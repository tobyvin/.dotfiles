local utils = require("tobyvin.utils")
local M = {}

M.set_custom_breakpoint = function()
	vim.ui.input({ prompt = "Condition: " }, function(condition)
		vim.ui.input({ prompt = "Hit condition: " }, function(hit_condition)
			vim.ui.input({ prompt = "Log point message: " }, function(log_message)
				require("dap").set_breakpoint(condition, hit_condition, log_message)
			end)
		end)
	end)
end

M.progress_start = function(session, body)
	local notif_data = utils.debug.get_notif_data("dap", body.progressId)

	local message = utils.debug.format_message(body.message, body.percentage)
	notif_data.notification = vim.notify(message, vim.log.levels.INFO, {
		title = utils.debug.format_title(body.title, session.config.type),
		icon = utils.status.signs.spinner.text[1],
		timeout = false,
		hide_from_history = false,
	})

	---@diagnostic disable-next-line: redundant-value
	notif_data.notification.spinner = 1, utils.status.update_spinner("dap", body.progressId)
end

M.progress_update = function(_, body)
	local notif_data = utils.debug.get_notif_data("dap", body.progressId)
	notif_data.notification =
		vim.notify(utils.debug.format_message(body.message, body.percentage), vim.log.levels.INFO, {
			replace = notif_data.notification,
			hide_from_history = false,
		})
end

M.progress_end = function(_, body)
	local notif_data = utils.debug.notifs["dap"][body.progressId]
	notif_data.notification =
		vim.notify(body.message and utils.debug.format_message(body.message) or "Complete", vim.log.levels.INFO, {
			icon = utils.status.signs.complete.text,
			replace = notif_data.notification,
			timeout = 3000,
		})
	notif_data.spinner = nil
end

M.setup = function()
	local status_ok, dap = pcall(require, "dap")
	if not status_ok then
		vim.notify("Failed to load module 'dap'", vim.log.levels.ERROR)
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

	dap.listeners.before.event_progressStart["progress-notifications"] = M.progress_start
	dap.listeners.before.event_progressUpdate["progress-notifications"] = M.progress_update
	dap.listeners.before.event_progressEnd["progress-notifications"] = M.progress_end

	dap.listeners.before.event_terminated["close_repl"] = dap.repl.close
	dap.listeners.before.event_exited["close_repl"] = dap.repl.close

	local keymap_restore = {}
	dap.listeners.after.event_initialized["keymap"] = function()
		for _, buf in pairs(vim.api.nvim_list_bufs()) do
			local keymaps = vim.api.nvim_buf_get_keymap(buf, "n")
			for _, keymap in pairs(keymaps) do
				if keymap.lhs == "K" then
					table.insert(keymap_restore, keymap)
					vim.api.nvim_buf_del_keymap(buf, "n", "K")
				end
			end
		end
		vim.keymap.set("n", "K", require("dap.ui.widgets").hover, { desc = "Hover" })
	end
	dap.listeners.before.event_terminated["keymap"] = function()
		for _, k in pairs(keymap_restore) do
			vim.keymap.set(k.mode, k.lhs, vim.F.if_nil(k.callback, k.rhs), { desc = k.desc })
		end
		keymap_restore = {}
	end

	utils.keymap.group("n", "<leader>d", { desc = "Debug" })
	vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
	vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
	vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
	vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
	vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
	vim.keymap.set("n", "<leader>da", dap.step_over, { desc = "Step Over" })
	vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
	vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
	vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Terminate" })
	vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
	vim.keymap.set("n", "<leader>dB", M.set_custom_breakpoint, { desc = "Custom Breakpoint" })

	-- Signs
	vim.fn.sign_define("DapBreakpoint", utils.debug.signs.breakpoint)
	vim.fn.sign_define("DapBreakpointCondition", utils.debug.signs.condition)
	vim.fn.sign_define("DapBreakpointRejected", utils.debug.signs.rejected)
	vim.fn.sign_define("DapStopped", utils.debug.signs.stopped)
	vim.fn.sign_define("DapLogPoint", utils.debug.signs.logpoint)
end

return M
