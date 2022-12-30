local M = {
	"echasnovski/mini.sessions",
	name = "sessions",
	event = { "VimLeavePre" },
	config = true,
}

function M.init()
	vim.keymap.set("n", "<leader>sw", function()
		require("mini.sessions").write()
	end, { desc = "write session" })

	vim.keymap.set("n", "<leader>sr", function()
		require("mini.sessions").read()
	end, { desc = "read session" })

	vim.keymap.set("n", "<leader>ss", function()
		require("mini.sessions").select()
	end, { desc = "select session" })

	vim.keymap.set("n", "<leader>sd", function()
		require("mini.sessions").delete()
	end, { desc = "delete session" })
end

function M.config()
	require("mini.sessions").setup()
end

return M
