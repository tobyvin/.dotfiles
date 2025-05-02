local mp = require("mp")
local msg = require("mp.msg")
local options = require("mp.options")

local default_options = {
	enabled = true,
}

local function paused_for_cache(name, value)
	msg.debug(("Property changed: %s: %s"):format(name, value))
	if name ~= "paused-for-cache" or value == nil then
		return
	end

	if value then
		msg.verbose("Reset playback speed due to cache pause")
		mp.set_property_number("speed", 1)
		mp.unobserve_property(paused_for_cache)
	end
end

local function speed(name, value)
	msg.debug(("Property changed: %s: %s"):format(name, value))
	if name ~= "speed" or value == nil then
		return
	end

	if value > 1 then
		mp.observe_property("paused-for-cache", "bool", paused_for_cache)
	else
		mp.unobserve_property(paused_for_cache)
	end
end

local function setup(opts)
	if opts.enabled then
		mp.observe_property("speed", "number", speed)
	end
end

options.read_options(default_options)
setup(default_options)
