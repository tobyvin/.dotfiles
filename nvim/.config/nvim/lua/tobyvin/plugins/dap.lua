local M = {}

M.setup = function()
	local status_ok, dap = pcall(require, "dap")
	if not status_ok then
		vim.notify("Failed to load module 'dap'", "error")
		return
	end

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
	-- dap.configurations.rust = dap.configurations.cpp

	-- nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
	-- nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
	-- nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
	-- nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
	-- nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
	-- nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
	-- nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
	-- nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
	-- nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>

	-- vim.api.nvim_create_user_command("Debug", dap.continue, { force = true })
	-- vim.api.nvim_create_user_command("BreakpointToggle", dap.toggle_breakpoint, { force = true })
	-- vim.api.nvim_create_user_command("BreakpointCond", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { force = true })
	-- vim.api.nvim_create_user_command("BreakpointLog", function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { force = true })
	-- vim.api.nvim_create_user_command("REPL", dap.repl.open, { force = true })

	-- require("which-key").register({
	-- 	d = {
	-- 		name = "DAP",
	-- 		b = { , "Format" },
	-- 		F = { M.toggle_auto_format, "Toggle Auto-Format" },
	-- 	},
	-- }, { prefix = "<leader>", buffer = 0 })

	if not pcall(require, "telescope") then
		require("telescope").load_extension("dap")
	end
end

return M
