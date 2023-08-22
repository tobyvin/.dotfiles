---@type LazyPluginSpec
local M = {
	"glacambre/firenvim",
	lazy = false,
	cond = not not vim.g.started_by_firenvim,
	opts = {
		localSettings = {
			[".*"] = {
				selector = [[ textarea:not([readonly]):not([class="handsontableInput"]), div[role="textbox"] ]],
				takeover = "never",
				cmdline = "firenvim",
			},
		},
	},
}

function M:build()
	require("lazy").load({
		plugins = self,
		wait = true,
	})

	vim.fn["firenvim#install"](0)
end

function M:config(opts)
	vim.g.firenvim_config = opts
end

return M
