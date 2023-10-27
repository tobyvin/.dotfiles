local M = {
	nlua = function(callback, config)
		callback({ type = "server", host = config.host, port = config.port })
	end,
	lldb = {
		type = "executable",
		command = "/usr/bin/lldb-vscode",
		name = "lldb",
	},
	gdb = {
		type = "executable",
		command = "gdb",
		args = { "-i", "dap" },
	},
	codelldb = function(on_config, _)
		local codelldb_path = vim.fn.exepath("codelldb")
		local liblldb_path = vim.fn.resolve(codelldb_path):gsub("/codelldb$", "/extension/lldb/lib/liblldb.so")

		on_config({
			type = "server",
			port = "${port}",
			host = "127.0.0.1",
			executable = {
				command = codelldb_path,
				args = { "--liblldb", liblldb_path, "--port", "${port}" },
			},
		})
	end,
}

return M
