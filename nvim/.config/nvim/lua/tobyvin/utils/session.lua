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

---@return string session_path
function M.path()
	if vim.v.this_session and vim.v.this_session ~= "" then
		return vim.v.this_session
	end

	local session_dir = table.concat({ vim.fn.stdpath("data"), "session" }, sep)
	local name = vim.loop.cwd():gsub(":", "++"):gsub(sep, "%%"):gsub("$", ".vim")

	if not name or name == "" then
		error(("Invalid session name: '%s'"):format(name))
	end

	return table.concat({ session_dir, name }, sep)
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

	vim.cmd.source(vim.fn.fnameescape(res))
end

return M
