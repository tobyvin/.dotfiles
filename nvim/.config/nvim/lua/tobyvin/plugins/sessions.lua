local M = {
	"echasnovski/mini.sessions",
	name = "sessions",
	event = { "VimLeavePre" },
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = true,
}

function M.init()
	local session_name = function()
		if vim.v.this_session ~= "" then
			return vim.fn.fnamemodify(vim.v.this_session, ":t")
		end
		local name, _ = vim.loop.cwd():gsub(":", "++"):gsub(require("plenary.path").path.sep, "%%")
		return name
	end

	vim.keymap.set("n", "<leader>sw", function()
		require("mini.sessions").write(session_name())
	end, { desc = "write session" })

	vim.keymap.set("n", "<leader>sr", function()
		require("mini.sessions").read(session_name())
	end, { desc = "read session" })

	vim.keymap.set("n", "<leader>ss", function()
		require("mini.sessions").select()
	end, { desc = "select session" })

	vim.keymap.set("n", "<leader>sd", function()
		require("mini.sessions").delete(session_name())
	end, { desc = "delete session" })
end

function M.config()
	require("plenary.path"):new(vim.fn.stdpath("data")):joinpath("session"):mkdir()

	require("mini.sessions").setup()
end

return M
