--- @class plugin.ui.SpinnerStep
--- @field text string Text to be show.
--- @field delay integer Timeout in ms before making next step.

--- @class plugin.ui.Spinner
--- @field private _callback fun(text: string)
--- @field private _steps Iter<plugin.ui.SpinnerStep>
--- @field private _timer uv.uv_timer_t|nil
local Spinner = {}
Spinner.__index = Spinner

function Spinner:start()
	if self._timer then
		return
	end

	self._timer = vim.uv.new_timer()
	self._timer:start(
		0,
		0,
		vim.schedule_wrap(function()
			local step = self._steps:next()
			self._callback(step.text)
			self._timer:set_repeat(step.delay)
			self._timer:again()
		end)
	)
end

--- Stops the spinner.
function Spinner:stop()
	if not self._timer then
		return
	end

	self._timer:stop()
	self._timer:close()
	self._timer = nil
end

--- @param steps plugin.ui.SpinnerStep[]|nil
--- @param callback fun(text: string) Callback to be executed
---   on every step update. Can include forcing `vim.cmd.redrawstatus()`, etc.
--- @return plugin.ui.Spinner
local function spinner(steps, callback)
	vim.validate("steps", steps, vim.islist, true, "list")
	steps = steps
		or {
			{ text = "⠇", delay = 100 },
			{ text = "⠏", delay = 100 },
			{ text = "⠋", delay = 100 },
			{ text = "⠙", delay = 100 },
			{ text = "⠹", delay = 100 },
			{ text = "⠸", delay = 100 },
			{ text = "⠼", delay = 100 },
			{ text = "⠴", delay = 100 },
			{ text = "⠦", delay = 100 },
			{ text = "⠧", delay = 100 },
		}

	local index = 1
	steps = vim.iter(setmetatable(steps, {
		__call = function(t)
			local v = t[index]
			index = index < #t and index + 1 or 1
			return v
		end,
	}))

	return setmetatable({
		_steps = steps,
		_callback = callback,
	} --[[@as plugin.ui.Spinner]], Spinner)
end

vim.ui.spinner = spinner
