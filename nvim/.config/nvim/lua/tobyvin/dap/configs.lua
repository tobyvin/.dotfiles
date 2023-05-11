local Job = require("plenary").job
local M = {}

local select_executable = function(cwd)
	cwd = vim.fn.expand(vim.F.if_nil(cwd, vim.fn.getcwd()))

	local finders = {
		fd = { "--type", "x", "--hidden" },
		fdfind = { "--type", "x", "--hidden" },
		find = { ".", "-type", "f", "--executable" },
	}

	local command, args
	for finder, finder_args in pairs(finders) do
		if vim.fn.executable(finder) == 1 then
			command = finder
			args = finder_args
		end
	end

	if command == nil then
		vim.notify("Failed to locate finder tool", vim.log.levels.ERROR, { title = "[dap.configs] select_executable" })
		return
	end

	local items = Job:new({
		command = command,
		args = args,
		cwd = cwd,
		enable_recording = true,
	}):sync()

	local result
	vim.ui.select(items, { kind = "executables" }, function(input)
		result = input
	end)
	return result
end

M.lua = {
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
}

M.c = {
	{
		name = "Launch c file",
		type = "codelldb",
		request = "launch",
		program = select_executable,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		runInTerminal = false,
	},
}

M.cpp = {
	{
		name = "Launch c++ file",
		type = "codelldb",
		request = "launch",
		program = select_executable,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		runInTerminal = false,
	},
}

M.rust = {
	{
		name = "Launch rust file",
		type = "codelldb",
		request = "launch",
		program = select_executable,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		runInTerminal = false,
	},
}

return M
