local M = {
	lua = {
		name = "Attach to running Neovim instance",
		type = "nlua",
		request = "attach",
		host = function()
			local host
			vim.ui.input({ prompt = "Host: ", default = "127.0.0.1" }, function(input)
				host = input
			end)
			return host
		end,
		port = function()
			local host
			vim.ui.input({ prompt = "Port: ", default = "7777" }, function(input)
				host = input
			end)
			return host
		end,
	},
	c = {
		{
			name = "Launch",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			runInTerminal = false,
		},
	},
	cpp = {
		{
			name = "Launch",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			runInTerminal = false,
		},
	},
	rust = {
		{
			name = "Launch",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			runInTerminal = false,
			initCommands = function()
				-- Find out where to look for the pretty printer Python module
				local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

				local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
				local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

				local commands = {}
				local file = io.open(commands_file, "r")
				if file then
					for line in file:lines() do
						table.insert(commands, line)
					end
					file:close()
				end
				table.insert(commands, 1, script_import)

				return commands
			end,
		},
	},
}

return M
