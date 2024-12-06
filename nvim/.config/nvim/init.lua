vim.g.mapleader = " "
vim.g.maplocalleader = vim.g.mapleader
vim.g.loaded_perl_provider = 0

---@diagnostic disable-next-line: param-type-mismatch
local lazypath = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy/lazy.nvim")
if not vim.uv.fs_stat(lazypath) then
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

require("lazy").setup("plugins", {
	defaults = {
		lazy = true,
		version = "*",
	},
	dev = {
		path = "~/.local/src",
		patterns = { "tobyvin" },
		fallback = true,
	},
	install = {
		colorscheme = {
			"gruvbox",
			"tokyonight",
		},
	},
	ui = {
		border = "single",
	},
	change_detection = {
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"netrwPlugin",
			},
		},
	},
})

pcall(vim.cmd.colorscheme, "gruvbox")
