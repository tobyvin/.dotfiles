local mp = require("mp")
local utils = require("mp.utils")
local msg = require("mp.msg")

local options = {
	enabled = true,
}

require("mp.options").read_options(options, "ipc")

if options.enabled then
	local ipc_path = mp.get_property_native("options/input-ipc-server")

	if ipc_path ~= "" then
		msg.info(("IPC socket already set: %s"):format(ipc_path))
	else
		local runtime_dir = os.getenv("XDG_RUNTIME_DIR") or os.getenv("TMPDIR") or "/tmp"
		ipc_path = utils.join_path(runtime_dir, string.format("mpv.%d.sock", utils.getpid()))

		pcall(os.remove, ipc_path)

		mp.set_property("options/input-ipc-server", ipc_path)

		msg.info(("Setup IPC socket: %s"):format(ipc_path))
	end

	mp.register_event("shutdown", function()
		pcall(os.remove, ipc_path)
		msg.info(("Removed IPC socket: %s"):format(ipc_path))
	end)
end
