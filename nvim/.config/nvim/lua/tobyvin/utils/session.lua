local M = {}

---@return string session_path
function M.path()
	if vim.v.this_session and vim.v.this_session ~= "" then
		return vim.v.this_session
	end

	local session_dir = table.concat({ vim.fn.stdpath("data"), "session" }, U.sep)
	local name = vim.loop.cwd():gsub(":", "++"):gsub(U.sep, "%%"):gsub("$", ".vim")

	if not name or name == "" then
		error(("Invalid session name: '%s'"):format(name))
	end

	return table.concat({ session_dir, name }, U.sep)
end

function M.write()
	local is_ok, res = pcall(M.path)
	if not is_ok then
		return vim.notify(res, vim.log.levels.ERROR)
	end

	vim.fn.mkdir(vim.fn.fnamemodify(res, ":p:h"), "p")

	if pcall(vim.cmd.mksession, { vim.fn.fnameescape(res), bang = true }) then
		vim.v.this_session = res
	end
end

function M.read()
	local is_ok, res = pcall(M.path)
	if not is_ok then
		return vim.notify(res, vim.log.levels.ERROR)
	end

	if vim.fn.filereadable(res) ~= 1 then
		return vim.notify("No session found", vim.log.levels.WARN)
	end

	if
		#vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 }) == 0
		or vim.fn.confirm("Reading session will overwrite buffers. Continue?", "&Yes\n&No") == 1
	then
		vim.cmd.source(vim.fn.fnameescape(res))
	end
end

return M
