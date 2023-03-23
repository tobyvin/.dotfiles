local M = {}

M.nlua = function(callback, config)
	callback({ type = "server", host = config.host, port = config.port })
end

M.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-vscode",
	name = "lldb",
}

M.rt_lldb = M.lldb

M.codelldb = {
	type = "server",
	port = "${port}",
	host = "127.0.0.1",
	executable = {
		command = "/usr/lib/codelldb/adapter/codelldb",
		args = { "--liblldb", "/usr/lib/codelldb/lldb/lib/liblldb.so", "--port", "${port}" },
	},
}

return M
