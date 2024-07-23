local mp = require("mp")

---@class twitch.Chat
---@field cwd string
---@field channel string
---@field process table
local Chat = {}

---@param channel string
---@return self
function Chat:new(channel)
	if not channel then
		error("channel name required")
	end

	self.__index = self

	return setmetatable({
		channel = channel,
		process = nil,
	}, self)
end

function Chat:register_bindings(bindings)
	local names = {}
	for name, callback in pairs(bindings) do
		mp.add_key_binding(nil, name, function()
			callback(self)
		end)
		table.insert(names, name)
	end
	return names
end

function Chat:open()
	if self.process then
		return
	end

	local opts = {
		name = "subprocess",
		capture_stdout = false,
		playback_only = false,
		args = {
			"/usr/bin/chatterino",
			("--channels=t:%s"):format(self.channel),
		},
	}

	self.process = mp.command_native_async(opts, function()
		self.process = nil
	end)
end

function Chat:close()
	if not self.process then
		return
	end

	mp.abort_async_command(self.process)
	self.process = nil
end

function Chat:toggle()
	if self.process then
		self:close()
	else
		self:open()
	end
end

return Chat
