local Path = require("plenary.path")
local session_dir = Path:new(vim.fn.stdpath("data"), "session")
local M = {}

function M.path()
	local name = vim.loop.cwd():gsub(":", "++"):gsub(Path.path.sep, "%%")
	local file = ("%s.vim"):format(name)
	return session_dir:joinpath(file).filename
end

function M.write()
	local path = M.path()

	session_dir:mkdir()
	vim.cmd.mksession({ vim.fn.fnameescape(path), bang = true })
end

function M.read()
	local file = M.path()
	if file and vim.fn.filereadable(file) ~= 0 then
		vim.cmd.source(vim.fn.fnameescape(file))
	else
		vim.notify("No session found", vim.log.levels.WARN)
	end
end

function M.setup()
	vim.keymap.set("n", "<leader>sr", M.read, { desc = "read session" })
	vim.keymap.set("n", "<leader>sw", M.write, { desc = "write session" })

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = vim.api.nvim_create_augroup("session", { clear = true }),
		callback = function()
			if #vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 }) > 0 then
				M.write()
			end
		end,
		desc = "write session on vim exit",
	})
end

return M
