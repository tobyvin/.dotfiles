local utils = require("tobyvin.utils")
local M = {}

local progress_start = function(session, body)
	local notif_data = utils.debug.get_notif_data("dap", body.progressId)

	local message = utils.debug.format_message(body.message, body.percentage)
	notif_data.notification = vim.notify(message, vim.log.levels.INFO, {
		title = utils.debug.format_title(body.title, session.config.type),
		icon = utils.status.signs.spinner.text[1],
		timeout = false,
		hide_from_history = false,
	})

	---@diagnostic disable-next-line: redundant-value
	notif_data.notification.spinner = 1, utils.status.update_spinner("dap", body.progressId)
end

local progress_update = function(_, body)
	local notif_data = utils.debug.get_notif_data("dap", body.progressId)
	notif_data.notification =
		vim.notify(utils.debug.format_message(body.message, body.percentage), vim.log.levels.INFO, {
			replace = notif_data.notification,
			hide_from_history = false,
		})
end

local progress_end = function(_, body)
	local notif_data = utils.debug.notifs["dap"][body.progressId]
	notif_data.notification =
		vim.notify(body.message and utils.debug.format_message(body.message) or "Complete", vim.log.levels.INFO, {
			icon = utils.status.signs.complete.text,
			replace = notif_data.notification,
			timeout = 3000,
		})
	notif_data.spinner = nil
end

M.setup = function()
	local dap = require("dap")

	dap.listeners.after.event_initialized["User"] = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "DapAttach" })
	end
	dap.listeners.before.event_terminated["User"] = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "DapDetach" })
		dap.repl.close()
	end
	dap.listeners.before.event_progressStart["progress-notifications"] = progress_start
	dap.listeners.before.event_progressUpdate["progress-notifications"] = progress_update
	dap.listeners.before.event_progressEnd["progress-notifications"] = progress_end
end

return M
