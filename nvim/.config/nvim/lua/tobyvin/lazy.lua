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

local config = require("lazy.view.config")
local commands = require("lazy.view.commands")

config.commands.reload = {
	desc = "Reload a plugin",
	id = 14,
	plugins = true,
	plugins_required = true,
}

commands.commands.reload = function(opts)
	local Config = require("lazy.core.config")
	local Util = require("lazy.core.util")

	for _, plugin in pairs(opts.plugins) do
		if type(plugin) == "string" then
			if Config.plugins[plugin] then
				plugin = Config.plugins[plugin]
			elseif Config.spec.disabled[plugin] then
				plugin = nil
			else
				Util.error("Plugin " .. plugin .. " not found")
				plugin = nil
			end
		end

		if plugin then
			require("lazy.core.loader").reload(plugin)
		end
	end
end

config.commands.deactivate = {
	desc = "Deactivate a plugin",
	id = 15,
	plugins = true,
	plugins_required = true,
}

commands.commands.deactivate = function(opts)
	local Config = require("lazy.core.config")
	local Util = require("lazy.core.util")

	for _, plugin in pairs(opts.plugins) do
		if type(plugin) == "string" then
			if Config.plugins[plugin] then
				plugin = Config.plugins[plugin]
			elseif Config.spec.disabled[plugin] then
				plugin = nil
			else
				Util.error("Plugin " .. plugin .. " not found")
				plugin = nil
			end
		end

		if plugin and plugin._.loaded then
			require("lazy.core.loader").deactivate(plugin)
		end
	end
end

require("lazy").setup("tobyvin.plugins", {
	defaults = {
		lazy = true,
	},
	concurrency = 5,
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
		notify = false,
	},
	ui = {
		border = "single",
	},
})
