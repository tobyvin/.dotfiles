local M = {}

M.signs = {
	breakpoint = { text = " ", texthl = "debugBreakpoint" },
	condition = { text = "ﳁ ", texthl = "debugBreakpoint" },
	rejected = { text = " ", texthl = "debugBreakpoint" },
	logpoint = { text = " ", texthl = "debugBreakpoint" },
	stopped = { text = " ", texthl = "debugBreakpoint", linehl = "debugPC", numhl = "debugPC" },
}

M.notifs = {}

M.get_notif_data = function(id, token)
	if not M.notifs[id] then
		M.notifs[id] = {}
	end

	if not M.notifs[id][token] then
		M.notifs[id][token] = {}
	end

	return M.notifs[id][token]
end

M.format_title = function(title, client)
	if type(client) == "table" then
		client = client.name
	end
	return client .. (#title > 0 and ": " .. title or "")
end

M.format_message = function(message, percentage)
	return (percentage and percentage .. "%\t" or "") .. (message or "")
end

return M
