local success, oil = pcall(require, "oil")
if not success then
	return
end

local git_ignored = setmetatable({}, {
	__index = function(t, k)
		local result = vim.system({
			"git",
			"ls-files",
			"--ignored",
			"--exclude-standard",
			"--others",
			"--directory",
		}, {
			cwd = k,
			text = true,
		}):wait()

		local ret = {}
		if result.code == 0 then
			for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
				line = line:gsub("/$", "")
				table.insert(ret, line)
			end
		end

		rawset(t, k, ret)
		return ret
	end,
})

oil.setup({
	default_file_explorer = true,
	skip_confirm_for_simple_edits = true,
	view_options = {
		is_hidden_file = function(name, _)
			local dir = oil.get_current_dir()
			return vim.list_contains(git_ignored[dir] or {}, name)
		end,
	},
})

---@param url string
---@param callback fun(url: string)
---@diagnostic disable-next-line: duplicate-set-field
require("oil.adapters.files").normalize_url = function(url, callback)
	local fs = require("oil.fs")
	local util = require("oil.util")

	local scheme, path = util.parse_url(url)
	assert(path)

	if fs.is_windows then
		if path == "/" then
			return callback(url)
		else
			local is_root_drive = path:match("^/%u$")
			if is_root_drive then
				return callback(url .. "/")
			end
		end
	end

	local os_path = vim.fn.fnamemodify(fs.posix_to_os_path(path), ":p")

	local realpath_cb = function(_, new_os_path)
		local realpath
		if fs.is_windows then
			realpath = os_path
		else
			realpath = new_os_path or os_path
		end

		vim.uv.fs_stat(
			realpath,
			vim.schedule_wrap(function(_, stat)
				local is_directory
				if stat then
					is_directory = stat.type == "directory"
				elseif vim.endswith(realpath, "/") or (fs.is_windows and vim.endswith(realpath, "\\")) then
					is_directory = true
				else
					local filetype = vim.filetype.match({ filename = vim.fs.basename(realpath) })
					is_directory = filetype == nil
				end

				if is_directory then
					local norm_path = util.addslash(fs.os_to_posix_path(realpath))
					callback(scheme .. norm_path)
				else
					callback(realpath)
				end
			end)
		)
	end

	vim.uv.fs_lstat(
		os_path,
		vim.schedule_wrap(function(_, stat)
			if stat and stat.type == "link" then
				realpath_cb(nil, os_path)
			else
				vim.uv.fs_realpath(os_path, realpath_cb)
			end
		end)
	)
end

vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })

vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("user.oil", { clear = true }),
	pattern = "SessionSavePre",
	callback = function(args)
		if vim.bo[args.buf].filetype == "oil" then
			oil.close()
			local has_orig_alt, alt_buffer = pcall(vim.api.nvim_win_get_var, 0, "oil_original_alternate")
			if has_orig_alt and vim.api.nvim_buf_is_valid(alt_buffer) then
				vim.fn.setreg("#", alt_buffer)
			end
		end
	end,
	desc = "close oil buffer on session save",
})
