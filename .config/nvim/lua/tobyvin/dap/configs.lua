local M = {
	lua = {
		{
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
	},
	c = {
		{
			name = "Launch",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input({
					prompt = "Path to executable: ",
					text = vim.fn.getcwd() .. "/",
					completion = "file",
				})
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
				return vim.fn.input({
					prompt = "Path to executable: ",
					text = vim.fn.getcwd() .. "/",
					completion = "file",
				})
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			runInTerminal = false,
		},
	},
	rust = {
		{
			name = "build",
			type = "codelldb",
			request = "launch",
			cargo = {
				args = { "build" },
			},
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			terminal = "console",
		},
		{
			name = "test --lib",
			type = "codelldb",
			request = "launch",
			cargo = {
				args = { "test", "--no-run", "--lib" },
			},
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			terminal = "console",
		},
	},
}

return M
