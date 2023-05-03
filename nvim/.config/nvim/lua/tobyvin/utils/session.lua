local M = {}

local sep = (function()
	if jit then
		local os = string.lower(jit.os)
		if os ~= "windows" then
			return "/"
		else
			return "\\"
		end
	else
		return package.config:sub(1, 1)
	end
end)()

local session_dir = vim.fn.stdpath("data") .. sep .. "session"

function M.path()
	if vim.v.this_session and vim.v.this_session ~= "" then
		return vim.v.this_session
	end

	local name = vim.loop.cwd():gsub(":", "++"):gsub(sep, "%%")
	return session_dir .. sep .. name .. ".vim"
end

function M.write()
	local path = M.path()

	vim.fn.mkdir(vim.fn.fnamemodify(path, ":p:h"), "p")
	if pcall(vim.cmd.mksession, { vim.fn.fnameescape(path), bang = true }) then
		vim.v.this_session = path
	end
end

function M.read()
	local file = M.path()
	if file and vim.fn.filereadable(file) ~= 0 then
		vim.cmd.source(vim.fn.fnameescape(file))
	else
		vim.notify("No session found", vim.log.levels.WARN)
	end
end

return M
