vim.api.nvim_create_user_command("W", "w", { desc = "write" })
vim.api.nvim_create_user_command("Q", "q", { desc = "quit" })
vim.api.nvim_create_user_command("Wq", "wq", { desc = "write quit" })
vim.api.nvim_create_user_command("SessionRead", U.session.read, { desc = "read session" })
vim.api.nvim_create_user_command("SessionWrite", U.session.write, { desc = "write session" })
vim.api.nvim_create_user_command("Scratch", function(cmdln)
	local bufnr = vim.api.nvim_create_buf(true, true)
	vim.bo[bufnr].filetype = cmdln.args[1]
	vim.api.nvim_set_current_buf(bufnr)
end, { nargs = "?", desc = "scratch buffer", complete = "filetype" })

vim.api.nvim_create_user_command("Runtime", function(opts)
	local items = vim.api.nvim_get_runtime_file(("*%s*"):format(opts.args), not opts.bang)
	U.select(items, {
		prompt = "select runtime file",
		format_item = function(item)
			return item:gsub(vim.env.HOME, "~")
		end,
	}, function(item)
		vim.cmd.edit(item)
	end)
end, { nargs = "?", bang = true, desc = "scratch buffer", complete = "filetype" })
