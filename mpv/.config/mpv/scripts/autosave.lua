local mp = require("mp")
local utils = require("mp.utils")

local function init()
	if not mp.get_property_bool("save-position-on-quit", true) then
		return
	end

	local o = {
		save_period = 60,
	}

	require("mp.options").read_options(o)

	local state_dir = utils.join_path((os.getenv("XDG_STATE_HOME") or "~/.local/state/"), "mpv/watch_later")
	local filename, title, path

	local function append_title()
		if not filename or not title then
			return
		end

		local proc = io.popen("printf '%s' '" .. path .. "' | /bin/md5sum -", "r")
		if not proc then
			return
		end

		local output = proc:read("*a")
		proc:close()

		if not output then
			return
		end

		local hash = output:gsub("[\n\r ]", ""):gsub("-", "")
		local file_path = utils.join_path(state_dir, string.upper(hash))

		local file, err = io.open(file_path, "a+")
		if file and not err then
			file:write(string.format("# title: %s\n", title))
			file:close()
		end
	end

	local function save()
		mp.command("write-watch-later-config")

		filename = mp.get_property_native("filename")
		title = mp.get_property_native("media-title")
		path = mp.get_property_native("path")

		if title and path then
			append_title()
		end
	end

	local save_period_timer = mp.add_periodic_timer(o.save_period, save)

	local function pause(_, paused)
		if paused then
			save()
			save_period_timer:kill()
		else
			save_period_timer:resume()
		end
	end

	local function on_end_file(data)
		mp.command("write-watch-later-config")
		append_title()
		if data.reason == "eof" or data.reason == "stop" then
			local playlist = mp.get_property_native("playlist")
			for _, entry in pairs(playlist) do
				if entry.id == data.playlist_entry_id then
					mp.commandv("delete-watch-later-config", entry.filename)
					return
				end
			end
		end
	end

	mp.observe_property("pause", "bool", pause)
	mp.register_event("end-file", on_end_file)
	save()
end

mp.register_event("file-loaded", init)
