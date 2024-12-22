---@diagnostic disable-next-line: param-type-mismatch
local session_dir = vim.fs.joinpath(vim.fn.stdpath("state"), "session")

---@return Iter
local function buf_iter()
	return vim.iter(vim.api.nvim_list_bufs())
end

---@param bufnr integer
---@return boolean
local function buf_is_valid(bufnr)
	return vim.api.nvim_buf_is_valid(bufnr)
		and vim.api.nvim_buf_is_loaded(bufnr)
		and vim.bo[bufnr].buflisted
		and vim.bo[bufnr].buftype ~= "nofile"
end

---@param bufnr integer
---@return boolean
local function buf_is_invalid(bufnr)
	return not buf_is_valid(bufnr)
end

---@param bufnr integer
local function buf_delete(bufnr, opts)
	vim.api.nvim_buf_delete(bufnr, opts or {})
end

---@return string session_path
local function session_name()
	if vim.v.this_session and vim.v.this_session ~= "" then
		return vim.v.this_session
	end

	local sep = vim.uv.os_uname().version:match("Windows") and "\\" or "/"
	local name = vim.uv.cwd():gsub(":", "++"):gsub(sep, "%%"):gsub("$", ".vim")

	if name == nil or name == "" then
		error(("Invalid session name: '%s'"):format(name))
	end

	return vim.fs.joinpath(session_dir, name)
end

local function write()
	local is_ok, res = pcall(session_name)
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

local function read()
	local is_ok, session_file = pcall(session_name)
	if not is_ok then
		return vim.notify(session_file, vim.log.levels.ERROR)
	end

	if vim.fn.filereadable(session_file) ~= 1 then
		return vim.notify(("No session found\nsession path: %s"):format(session_file), vim.log.levels.WARN)
	end

	if
		not buf_iter():any(buf_is_valid)
		or vim.fn.confirm("Reading session will overwrite existing buffers. Continue?", "&Yes\n&No") == 1
	then
		buf_iter():filter(buf_is_invalid):map(buf_delete)
		vim.cmd.source(vim.fn.fnameescape(session_file))
	end
end

local augroup = vim.api.nvim_create_augroup("session", { clear = true })

vim.api.nvim_create_user_command("SessionRead", read, { desc = "read session" })
vim.api.nvim_create_user_command("SessionWrite", write, { desc = "write session" })

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = function()
		if vim.fn.argc() == 0 then
			vim.bo.buftype = "nofile"
			vim.bo.bufhidden = "wipe"

			vim.keymap.set("n", "<leader>sr", read, {
				buffer = 0,
				desc = "read session",
			})
		end
		return true
	end,
	desc = "read session",
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = augroup,
	callback = function()
		if vim.fn.argc() == 0 and buf_iter():any(buf_is_valid) then
			pcall(write)
		end
	end,
	desc = "write session",
})
