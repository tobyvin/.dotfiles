do
	--- Displays a notification to the user by writing to |:messages|.
	---@param msg string Content of the notification to show to the user.
	---@param level integer|nil One of the values from |vim.log.levels|.
	---@param opts table|nil Optional parameters. Currenly only uses `opts.title`.
	local function notify(msg, level, opts) -- luacheck: no unused args
		if opts and opts.title then
			msg = string.format("%s: %s", opts.title, msg)
		end

		if level == vim.log.levels.ERROR then
			vim.api.nvim_echo({ { msg } }, true, { err = true })
		elseif level == vim.log.levels.WARN then
			vim.api.nvim_echo({ { msg, "WarningMsg" } }, true, {})
		else
			vim.api.nvim_echo({ { msg } }, true, {})
		end
	end

	vim.notify = notify
end

do
	--- @type table<string,table<string,true>>
	local notified = setmetatable({}, {
		__index = function()
			return {}
		end,
	})

	--- Displays a notification only one time.
	---
	--- Like |vim.notify()|, but subsequent calls with the same message (and title)
	--- will not display a notification.
	---
	---@param msg string Content of the notification to show to the user.
	---@param level integer|nil One of the values from |vim.log.levels|.
	---@param opts table|nil Optional parameters. Currently only uses `opts.title`.
	---@return boolean true if message was displayed, else false
	local function notify_once(msg, level, opts)
		opts = opts or {}

		if not notified[msg] then
			vim.notify(msg, level, opts)
			notified[opts.title or "_"][msg] = true
			return true
		end
		return false
	end

	vim.notify_once = notify_once
end
