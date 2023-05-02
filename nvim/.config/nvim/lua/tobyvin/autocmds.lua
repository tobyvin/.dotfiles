local augroup = vim.api.nvim_create_augroup("tobyvin", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ macro = true })
	end,
	desc = "Highlight yank",
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = vim.api.nvim_create_augroup("session", { clear = true }),
	callback = function()
		if #vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 }) > 0 then
			require("tobyvin.utils.session").write()
		end
	end,
	desc = "write session on vim exit",
})

vim.api.nvim_create_autocmd("FocusLost", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.g.system_clipboard = {
			regtype = vim.fn.getregtype("+"),
			contents = vim.split(vim.fn.getreg("+"), "\n"),
		}
	end,
	desc = "clipboard sync",
})

vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
	group = augroup,
	pattern = "*",
	callback = function(args)
		local system_clipboard = {
			regtype = vim.fn.getregtype("+"),
			contents = vim.split(vim.fn.getreg("+"), "\n"),
		}

		if
			args.event == "VimEnter"
			or vim.g.system_clipboard ~= nil and not vim.deep_equal(vim.g.system_clipboard, system_clipboard)
		then
			require("neoclip")
			require("neoclip.storage").insert(system_clipboard, "yanks")
		end

		vim.g.system_clipboard = nil
	end,
	desc = "clipboard sync",
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	callback = function(args)
		local file = vim.loop.fs_realpath(args.match) or args.match
		local parent = vim.fn.fnamemodify(file, ":h")
		local stat = vim.loop.fs_stat(parent)

		if not stat then
			local prompt = string.format("'%s' does not exist. Create it?", parent)
			if vim.fn.confirm(prompt, "&Yes\n&No") == 1 then
				vim.fn.mkdir(vim.fn.fnamemodify(parent, ":p"), "p")
			end
		elseif stat.type ~= "directory" then
			local msg = string.format("cannot create directory ‘%s’: Not a directory", parent)
			vim.notify(msg, vim.log.levels.ERROR)
		end
	end,
	desc = "Check for missing directory on write",
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = "*",
	callback = function()
		local cursor = vim.api.nvim_win_get_cursor(0)
		vim.cmd("%s/\\s\\+$//e")
		vim.api.nvim_win_set_cursor(0, cursor)
	end,
	desc = "Trim whitespace on write",
})
