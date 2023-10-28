local session = require("tobyvin.utils.session")

vim.api.nvim_create_user_command("W", "w", { desc = "write" })
vim.api.nvim_create_user_command("Q", "q", { desc = "quit" })
vim.api.nvim_create_user_command("Wq", "wq", { desc = "write quit" })
vim.api.nvim_create_user_command("SessionRead", session.read, { desc = "read session" })
vim.api.nvim_create_user_command("SessionWrite", session.write, { desc = "write session" })
vim.api.nvim_create_user_command("Scratch", function(cmdln)
	local bufnr = vim.api.nvim_create_buf(true, true)
	vim.bo[bufnr].filetype = cmdln.args[1]
	vim.api.nvim_set_current_buf(bufnr)
end, { nargs = "?", desc = "scratch buffer", complete = "filetype" })
