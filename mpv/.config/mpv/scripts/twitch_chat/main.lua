local mp = require("mp")
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

local function setup(name, value)
	msg.debug(("Property changed: %s: %s"):format(name, value))
	if not value then
		return
	end

	local channel = value:match("twitch%.tv/([^/ ]+)")

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

mp.observe_property("path", "string", setup)
mp.observe_property("media-title", "string", setup)
