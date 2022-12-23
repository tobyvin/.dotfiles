local M = {
	"Shatur/neovim-session-manager",
	lazy = false,
}

function M.config()
	local session_manager = require("session_manager")

	session_manager.setup({
		autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
	})

	vim.keymap.set("n", "<leader>ss", session_manager.save_current_session, { desc = "save session" })
	vim.keymap.set("n", "<leader>sl", session_manager.load_current_dir_session, { desc = "load session" })
	vim.keymap.set("n", "<leader>sL", session_manager.load_session, { desc = "pick session" })
	vim.keymap.set("n", "<leader>sr", session_manager.load_last_session, { desc = "last session" })
	vim.keymap.set("n", "<leader>sd", session_manager.delete_session, { desc = "delete session" })
end

return M
