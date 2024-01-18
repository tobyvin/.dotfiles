local M = {}

---@return string session_path
function M.session_path()
	if vim.v.this_session and vim.v.this_session ~= "" then
		return vim.v.this_session
	end

	local name = vim.loop.cwd():gsub(":", "++"):gsub(U.fs.sep, "%%"):gsub("$", ".vim")

	if name == nil or name == "" then
		error(("Invalid session name: '%s'"):format(name))
	end

	return U.fs.xdg.data("nvim", "session", name)
end

function M.write()
	local is_ok, res = pcall(M.session_path)
	if not is_ok then
		return vim.notify(res, vim.log.levels.ERROR)
	end

	vim.fn.mkdir(vim.fn.fnamemodify(res, ":p:h"), "p")

	vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
	if pcall(vim.cmd.mksession, { vim.fn.fnameescape(res), bang = true }) then
		vim.v.this_session = res
	end
	vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePost" })
end

function M.read()
	local is_ok, session_file = pcall(M.session_path)
	if not is_ok then
		return vim.notify(session_file, vim.log.levels.ERROR)
	end

	if vim.fn.filereadable(session_file) ~= 1 then
		return vim.notify(("No session found\nsession path: %s"):format(session_file), vim.log.levels.WARN)
	end

	if
		not U.buf.iter():any(U.buf.is_valid)
		or vim.fn.confirm("Reading session will overwrite existing buffers. Continue?", "&Yes\n&No") == 1
	then
		U.buf.iter():filter(U.buf.is_invalid):map(U.buf.delete)
		vim.cmd.source(vim.fn.fnameescape(session_file))
	end
end

function M.on_exit()
	if vim.fn.argc() == 0 and U.buf.iter():any(U.buf.is_valid) then
		pcall(M.write)
	end
end

return M
