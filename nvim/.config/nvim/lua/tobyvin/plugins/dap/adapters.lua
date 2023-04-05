local M = {}

M.nlua = function(callback, config)
	callback({ type = "server", host = config.host, port = config.port })
end

M.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-vscode",
	name = "lldb",
}

M.codelldb = function(on_config, _)
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
end

M.rt_lldb = M.codelldb

return M
