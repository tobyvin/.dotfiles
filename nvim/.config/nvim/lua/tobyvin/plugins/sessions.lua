---@diagnostic disable: missing-parameter, duplicate-set-field
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
	vim.keymap.set("n", "<leader>sr", function()
		require("mini.sessions").read()
	end, { desc = "read session" })

	vim.keymap.set("n", "<leader>sw", function()
		require("mini.sessions").write()
	end, { desc = "write session" })

	vim.keymap.set("n", "<leader>sd", function()
		require("mini.sessions").delete()
	end, { desc = "delete session" })

	vim.keymap.set("n", "<leader>ss", function()
		require("mini.sessions").select()
	end, { desc = "select session" })
end

function M.config()
	local session_dir = require("plenary.path"):new(vim.fn.stdpath("data")):joinpath("session")

	session_dir:mkdir()

	local session_name = function()
		if vim.v.this_session ~= "" then
			return vim.fn.fnamemodify(vim.v.this_session, ":t")
		end

		return vim.loop.cwd():gsub(":", "++"):gsub(session_dir.path.sep, "%%")
	end

	local read = require("mini.sessions").read
	require("mini.sessions").read = function(name)
		name = vim.F.if_nil(name, session_name())
		if session_dir:joinpath(name):exists() then
			read(name)
		else
			vim.notify("No session found", vim.log.levels.WARN)
		end
	end

	local write = require("mini.sessions").write
	require("mini.sessions").write = function(name)
		name = vim.F.if_nil(name, session_name())

		if not session_dir:joinpath(name):exists() or #vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 }) > 0 then
			write(name)
		end
	end

	local delete = require("mini.sessions").delete
	require("mini.sessions").delete = function(name)
		name = vim.F.if_nil(name, session_name())
		delete(name)
	end

	require("mini.sessions").setup()
end

return M
