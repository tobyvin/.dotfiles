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
	defaults = {
		lazy = false,
	},
	dev = {
		path = "~/src",
	},
	install = {
		colorscheme = {
			"gruvbox",
			"tokyonight",
		},
	},
	checker = {
		enabled = true,
	},
	ui = {
		border = "single",
	},
})

vim.keymap.set("n", "<leader>p", "<cmd>:Lazy<cr>")
