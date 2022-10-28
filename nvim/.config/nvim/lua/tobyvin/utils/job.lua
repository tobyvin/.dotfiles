local M = {}

---@param cmd? string Default command to run.
---@param args string[]? Default arguments.
---@param quiet boolean? Silence stdout of the job.
M.cmd = function(cmd, args, quiet)
	quiet = quiet or false
	cmd = cmd or ""
	args = args or {}
	vim.ui.input({
		prompt = "Run command:",
		default = cmd .. " " .. table.concat(args, " "),
		completion = "shellcmd",
		kind = "cmd",
	}, function(input)
		if input ~= nil then
			args = {}
			for i, arg in ipairs(vim.split(input, " ", { trimempty = true })) do
				if i == 1 then
					cmd = arg
				else
					table.insert(args, vim.fn.expand(arg))
				end
			end
			M.with_notify(cmd, args, quiet):start()
		end
	end)
end

M.with_notify = function(cmd, args, quiet)
	local Job = require("plenary").job
	local notification
	local win, height
	local output = ""
	local length = 0
	local width = 0

	local on_data = function(status, data)
		if data ~= nil then
			output = output .. data .. "\n"
			width = math.max(width, string.len(data) + 2)
		end

		notification = vim.notify(vim.trim(output), vim.log.levels.INFO, {
			title = string.format("[%s] %s", cmd, status),
			icon = M.status_signs[status].text,
			replace = notification,
			on_open = function(win_)
				win, height = win_, vim.api.nvim_win_get_height(win_)
			end,
			timeout = 10000,
		})

		vim.api.nvim_win_set_width(win, width)
		if height then
			vim.api.nvim_win_set_height(win, height + length)
		end

		length = length + 1
	end

	local on_start = function()
		if not quiet then
			on_data("started", string.format("$ %s %s", cmd, table.concat(args, " ")))
		end
	end

	local on_stdout = function(_, data)
		if not quiet then
			on_data("running", data)
		end
	end

	local on_stderr = function(_, data)
		on_data("running", data)
	end

	local on_exit = function(_, code)
		if code ~= 0 then
			on_data("failed")
		elseif not quiet then
			on_data("completed")
		end
	end

	return Job:new({
		command = cmd,
		args = args,
		enabled_recording = true,
		on_start = vim.schedule_wrap(on_start),
		on_stdout = vim.schedule_wrap(on_stdout),
		on_stderr = vim.schedule_wrap(on_stderr),
		on_exit = vim.schedule_wrap(on_exit),
	})
end

return M
