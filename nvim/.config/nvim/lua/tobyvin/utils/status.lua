local M = {}

M.signs = {
	started = { text = "ﳁ ", texthl = "diffChanged" },
	running = { text = "ﳁ ", texthl = "DiagnosticSignInfo" },
	failed = { text = " ", texthl = "DiagnosticSignError" },
	completed = { text = " ", texthl = "diffAdded" },
	spinner = { text = { "⣷", "⣯", "⣟", "⡿", "⢿", "⣻", "⣽", "⣾" }, texthl = "DiagnosticSignInfo" },
}

M.update_spinner = function(client_id, token)
	local notif_data = M.get_notif_data(client_id, token)

	if notif_data.spinner then
		local new_spinner = (notif_data.spinner + 1) % #M.status_signs.spinner.text
		notif_data.spinner = new_spinner

		notif_data.notification = vim.notify(nil, nil, {
			hide_from_history = true,
			icon = M.status_signs.spinner.text[new_spinner],
			replace = notif_data.notification,
		})

		vim.defer_fn(function()
			M.update_spinner(client_id, token)
		end, 100)
	end
end

return M
