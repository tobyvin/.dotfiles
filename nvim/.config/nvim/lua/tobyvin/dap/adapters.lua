local dap_utils = require("tobyvin.utils.dap")

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
	codelldb = {
		type = "server",
		port = "${port}",
		host = "127.0.0.1",
		executable = {
			command = vim.fn.exepath("codelldb"),
			args = {
				"--liblldb",
				(vim.fn.resolve(vim.fn.exepath("codelldb")):gsub("/codelldb$", "/extension/lldb/lib/liblldb.so")),
				"--port",
				"${port}",
			},
		},
		enrich_config = function(config, on_config)
			if config["cargo"] ~= nil then
				on_config(dap_utils.cargo_inspector(config))
			end
		end,
	},
}

return M
