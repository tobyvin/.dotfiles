local M = {
	client_notifs = {},
	spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
}

M.get_notif_data = function(client_id, token)
	if not M.client_notifs[client_id] then
		M.client_notifs[client_id] = {}
	end

	if not M.client_notifs[client_id][token] then
		M.client_notifs[client_id][token] = {}
	end

	return M.client_notifs[client_id][token]
end

M.update_spinner = function(client_id, token)
	local notif_data = M.get_notif_data(client_id, token)

	if notif_data.spinner then
		local new_spinner = (notif_data.spinner + 1) % #M.spinner_frames
		notif_data.spinner = new_spinner

		notif_data.notification = vim.notify(nil, nil, {
			hide_from_history = true,
			icon = M.spinner_frames[new_spinner],
			replace = notif_data.notification,
		})

		vim.defer_fn(function()
			M.update_spinner(client_id, token)
		end, 100)
	end
end

M.format_title = function(title, client_name)
	return client_name .. (#title > 0 and ": " .. title or "")
end

M.format_message = function(message, percentage)
	return (percentage and percentage .. "%\t" or "") .. (message or "")
end

return M
