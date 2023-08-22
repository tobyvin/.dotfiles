---@type LazyPluginSpec
local M = {
	"andweeb/presence.nvim",
	event = {
		"FocusGained",
		"TextChanged",
		"VimLeavePre",
		"WinEnter",
		"WinLeave",
		"BufEnter",
		"BufAdd",
	},
	opts = {
		focus_lost_delay = 300,
	},
}

function M:config(opts)
	local Presence = require("presence")

	local plugin_managers = require("presence/plugin_managers")
	plugin_managers["lazy"] = "lazy"

	-- HACK: Overwrite functions to remove WSL related stuff
	function Presence:get_discord_socket_path()
		local sock_name = "discord-ipc-0"
		local sock_path = nil

		if self.os.name == "windows" then
			-- Use named pipe in NPFS for Windows
			sock_path = [[\\.\pipe\]] .. sock_name
		elseif self.os.name == "macos" then
			-- Use $TMPDIR for macOS
			local path = os.getenv("TMPDIR")

			if path then
				sock_path = path:match("/$") and path .. sock_name or path .. "/" .. sock_name
			end
		elseif self.os.name == "linux" then
			-- Check various temp directory environment variables
			local env_vars = {
				"XDG_RUNTIME_DIR",
				"TEMP",
				"TMP",
				"TMPDIR",
			}

			for i = 1, #env_vars do
				local var = env_vars[i]
				local path = os.getenv(var)
				if path then
					self.log:debug(string.format("Using runtime path: %s", path))
					sock_path = path:match("/$") and path .. sock_name or path .. "/" .. sock_name
					break
				end
			end
		end

		return sock_path
	end

	-- HACK: Fix grep command for neovim socket
	function Presence:get_nvim_socket_paths(on_done)
		self.log:debug("Getting nvim socket paths...")
		local sockets = {}
		local parser = {}
		local cmd

		if self.os.name == "windows" then
			cmd = {
				"powershell.exe",
				"-Command",
				[[(Get-ChildItem \\.\pipe\).FullName | findstr 'nvim']],
			}
		elseif self.os.name == "macos" then
			if vim.fn.executable("netstat") == 0 then
				self.log:warn("Unable to get nvim socket paths: `netstat` command unavailable")
				return
			end

			-- Define macOS BSD netstat output parser
			function parser.parse(data)
				return data:match("%s(/.+)")
			end

			cmd = table.concat({
				"netstat -u",
				[[grep --color=never "nvim.*/0"]],
			}, "|")
		elseif self.os.name == "linux" then
			if vim.fn.executable("ss") == 1 then
				-- Use `ss` if available
				cmd = table.concat({
					"ss -lx",
					[[grep "nvim.*\.0"]],
				}, "|")

				-- Define ss output parser
				function parser.parse(data)
					return data:match("%s(/.-)%s")
				end
			elseif vim.fn.executable("netstat") == 1 then
				-- Use `netstat` if available
				cmd = table.concat({
					"netstat -u",
					[[grep --color=never "nvim.*\.0"]],
				}, "|")

				-- Define netstat output parser
				function parser.parse(data)
					return data:match("%s(/.+)")
				end
			else
				local warning_msg = "Unable to get nvim socket paths: `netstat` and `ss` commands unavailable"
				self.log:warn(warning_msg)
				return
			end
		else
			local warning_fmt = "Unable to get nvim socket paths: Unexpected OS: %s"
			self.log:warn(string.format(warning_fmt, self.os.name))
			return
		end

		local function handle_data(_, data)
			if not data then
				return
			end

			for i = 1, #data do
				local socket = parser.parse and parser.parse(vim.trim(data[i])) or vim.trim(data[i])
				if socket and socket ~= "" and socket ~= self.socket then
					table.insert(sockets, socket)
				end
			end
		end

		local function handle_error(_, data)
			if not data then
				return
			end

			if data[1] ~= "" then
				self.log:error(string.format("Unable to get nvim socket paths: %s", data[1]))
			end
		end

		local function handle_exit()
			self.log:debug(string.format("Got nvim socket paths: %s", vim.inspect(sockets)))
			on_done(sockets)
		end

		local cmd_str = type(cmd) == "table" and table.concat(cmd, ", ") or cmd
		self.log:debug(string.format("Executing command: `%s`", cmd_str))
		vim.fn.jobstart(cmd, {
			on_stdout = handle_data,
			on_stderr = handle_error,
			on_exit = handle_exit,
		})
	end

	function Presence:handle_focus_lost()
		self:start_idle_timer(self.options.focus_lost_delay, function()
			self:cancel()
		end)
	end

	function Presence:start_idle_timer(timeout, callback)
		local idle_timeout = timeout * 1000
		self.idle_timer = vim.fn.timer_start(idle_timeout, callback)
	end

	function Presence:cancel_idle_timer()
		if self.idle_timer then
			vim.fn.timer_stop(self.idle_timer)
		end
		self.idle_timer = nil
	end

	Presence.setup(opts)

	vim.api.nvim_create_autocmd("FocusLost", {
		callback = function()
			Presence:handle_focus_lost()
		end,
	})

	vim.api.nvim_create_autocmd("FocusGained", {
		callback = function()
			Presence:cancel_idle_timer()
		end,
	})
end

return M
