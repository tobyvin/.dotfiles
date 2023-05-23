vim.api.nvim_create_user_command("W", "w", { desc = "write" })
vim.api.nvim_create_user_command("Q", "q", { desc = "quit" })
vim.api.nvim_create_user_command("Wq", "wq", { desc = "write quit" })
