local Chat = require("chat")
local msg = require("mp.msg")

---@param chat twitch.Chat
---@param bindings table<string, fun(self: twitch.Chat)>
---@return string[] script_bindings list bindable 'script-binding' names
local function register_bindings(chat, bindings)
	local names = {}
	for name, callback in pairs(bindings) do
		mp.add_key_binding(nil, name, function()
			callback(chat)
		end)
		table.insert(names, name)
	end
	return names
end

local function get_channel()
	local path = mp.get_property_native("path")
	if path == "-" then
		return mp.get_property_native("media-title"):match("twitch.tv/(%S+)")
	else
		return path:match("twitch%.tv/([^/]+)$")
	end
end

local function setup()
	local channel = get_channel()

	if not channel then
		msg.debug("Twitch channel not found")
		return
	end

	msg.info(("Found twitch channel: %s"):format(channel))

	local chat = Chat:new(channel)

	local names = register_bindings(chat, {
		chat_open = Chat.open,
		chat_close = Chat.close,
		chat_toggle = Chat.toggle,
	})

	msg.verbose(("Registering script-bindings: %s"):format(table.concat(names, ", ")))
end

mp.register_event("start-file", setup)
