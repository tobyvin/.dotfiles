local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("tobyvin.plugins", {
	defaults = {
		lazy = true,
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
