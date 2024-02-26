vim.keymap.set("n", "<leader>sr", U.session.read, {
	buffer = 0,
	desc = "read session",
})

vim.keymap.set("n", "<C-n>", U.dashboard.next_fortune, {
	buffer = 0,
	desc = "next fortune",
})
