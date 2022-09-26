local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, session_manager = pcall(require, "session_manager")
	if not status_ok then
		vim.notify("Failed to load module 'session_manager'", "error")
		return
	end

	session_manager.setup({
		autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
	})

	utils.create_map_group("n", "<leader>s", { desc = "Sessions" })
	vim.keymap.set("n", "<leader>ss", session_manager.save_current_session, { desc = "Save session" })
	vim.keymap.set("n", "<leader>sl", session_manager.load_current_dir_session, { desc = "Load current session" })
	vim.keymap.set("n", "<leader>sL", session_manager.load_session, { desc = "Load session" })
	vim.keymap.set("n", "<leader>sr", session_manager.load_last_session, { desc = "Load last session" })
	vim.keymap.set("n", "<leader>sd", session_manager.delete_session, { desc = "Delete session" })
end

return M
