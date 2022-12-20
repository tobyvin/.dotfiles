local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("tobyvin.plugins", {
	dev = { path = "~/src" },
	install = { colorscheme = { "gruvbox" } },
	checker = { enabled = true },
})

vim.keymap.set("n", "<leader>p", "<cmd>:Lazy<cr>")
