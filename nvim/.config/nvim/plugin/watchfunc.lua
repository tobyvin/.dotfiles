-- See: https://github.com/neovim/neovim/issues/23291

local FileChangeType = require("vim._watch").FileChangeType

local event_map = {
	CREATE = FileChangeType.Created,
	MOVED_TO = FileChangeType.Created,
	MODIFY = FileChangeType.Changed,
	MOVED_FROM = FileChangeType.Deleted,
	DELETE = FileChangeType.Deleted,
}

if vim.fn.executable("inotifywait") == 1 then
	require("vim.lsp._watchfiles")._watchfunc = function(path, _, callback)
		local inotifywait = vim.system({
			"inotifywait",
			"--monitor",
			"--recursive",
			"--format='%w%f%0%e'",
			"--event",
			"create",
			"--event",
			"moved_to",
			"--event",
			"modify",
			"--event",
			"moved_from",
			"--event",
			"delete",
			path,
		}, {
			stdout = function(_, data)
				for line in vim.gsplit(data, "\0", { trimempty = true }) do
					local event = vim.split(line, ":")
					local file = event[1]
					local change = event_map[event[2]]
					if change then
						callback(file, change)
					end
				end
			end,
			text = true,
		})

		return function()
			inotifywait:kill("sigint")
		end
	end
end
