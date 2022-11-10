local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, session_manager = pcall(require, "session_manager")
	if not status_ok then
		vim.notify("Failed to load module 'session_manager'", vim.log.levels.ERROR)
		return
	end

	session_manager.setup({
		autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
	})

	utils.keymap.group("n", "<leader>s", { desc = "sessions" })
	vim.keymap.set("n", "<leader>ss", session_manager.save_current_session, { desc = "save session" })
	vim.keymap.set("n", "<leader>sl", session_manager.load_current_dir_session, { desc = "load current session" })
	vim.keymap.set("n", "<leader>sL", session_manager.load_session, { desc = "load session" })
	vim.keymap.set("n", "<leader>sr", session_manager.load_last_session, { desc = "load last session" })
	vim.keymap.set("n", "<leader>sd", session_manager.delete_session, { desc = "delete session" })
end

return M
