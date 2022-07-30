local utils = require("tobyvin.utils")
local M = {
	dapui_win = nil,
	dapui_tab = nil,
}

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

M.open_in_tab = function()
	if M.dapui_win and vim.api.nvim_win_is_valid(M.dapui_win) then
		vim.api.nvim_set_current_win(M.dapui_win)
		return
	end

	vim.cmd("tabedit %")
	M.dapui_win = vim.fn.win_getid()
	M.dapui_tab = vim.api.nvim_win_get_tabpage(M.dapui_win)

	require("dapui").open({})
end

M.close_tab = function()
	require("dapui").close({})

	if M.dapui_tab and vim.api.nvim_tabpage_is_valid(M.dapui_tab) then
		local tabnr = vim.api.nvim_tabpage_get_number(M.dapui_tab)
		vim.cmd("tabclose " .. tabnr)
	end

	M.dapui_win = nil
	M.dapui_tab = nil
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
	require("nvim-dap-virtual-text").setup()

	-- DAPUI
	require("dapui").setup()

	dap.listeners.before.event_terminated["close_repl"] = dap.repl.close
	dap.listeners.before.event_exited["close_repl"] = dap.repl.close

	-- Attach DAP UI to DAP events
	dap.listeners.after.event_initialized["dapui_config"] = M.open_in_tab
	dap.listeners.before.event_terminated["dapui_config"] = M.close_tab
	dap.listeners.before.event_exited["dapui_config"] = M.close_tab
	dap.listeners.before.disconnect["dapui_config"] = M.close_tab

	-- Telescope
	require("telescope").load_extension("dap")

	-- Keymaps
	vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
	vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
	vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
	vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })

	local nmap = utils.create_map_group("n", "<leader>d", { desc = "Debug" })
	nmap("d", dap.continue, { desc = "Continue" })
	nmap("a", dap.step_over, { desc = "Step Over" })
	nmap("i", dap.step_into, { desc = "Step Into" })
	nmap("o", dap.step_out, { desc = "Step Out" })
	nmap("q", dap.terminate, { desc = "Terminate" })

	nmap("b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
	nmap("B", M.set_custom_breakpoint, { desc = "Custom Breakpoint" })

	nmap("c", require("telescope").extensions.dap.commands, { desc = "Commands" })
	nmap("C", require("telescope").extensions.dap.configurations, { desc = "Configurations" })
	nmap("l", require("telescope").extensions.dap.list_breakpoints, { desc = "List Breakpoints" })
	nmap("v", require("telescope").extensions.dap.variables, { desc = "Variables" })
	nmap("f", require("telescope").extensions.dap.frames, { desc = "Frames" })

	nmap("e", M.eval, { desc = "Eval" })

	-- Signs
	vim.fn.sign_define("DapBreakpoint", utils.debug_signs.breakpoint)
	vim.fn.sign_define("DapBreakpointCondition", utils.debug_signs.condition)
	vim.fn.sign_define("DapBreakpointRejected", utils.debug_signs.rejected)
	vim.fn.sign_define("DapStopped", utils.debug_signs.stopped)
	vim.fn.sign_define("DapLogPoint", utils.debug_signs.logpoint)
end

return M
