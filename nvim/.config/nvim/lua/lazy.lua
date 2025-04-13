local lazypath = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
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

-- Unload this package (lua/lazy.lua) to allow lazy to load itself
package.loaded["lazy"] = nil
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		import = "plugins",
	},
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
		border = vim.o.winborder,
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
} --[[@as LazyConfig]])
