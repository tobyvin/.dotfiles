---@type LazyPluginSpec
local M = {
	"stevearc/dressing.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		input = {
			get_config = function(opts)
				if opts.kind == "cmd" then
					return {
						relative = "win",
						insert_only = false,
					}
				end
			end,
		},
		select = {
			get_config = function(opts)
				if opts.kind == "Ring history" then
					return {
						telescope = require("telescope.themes").get_dropdown({ preview = true }),
					}
				end
			end,
			format_item_override = {
				["rust-tools/debuggables"] = function(item)
					item = item:gsub(" %-%-no%-run", "")
					item = item:gsub(" %-%-package", " -p")
					item = item:gsub(" %-%-all%-features", "")
					item = item:gsub(" %-%-all%-targets", "")
					item = item:gsub(" %-%-exact", "")
					item = item:gsub(" %-%-nocapture", "")
					return item
				end,
			},
		},
	},
}

function M.init()
	---@diagnostic disable-next-line: duplicate-set-field
	vim.ui.select = function(...)
		require("lazy").load({ plugins = { "dressing.nvim" } })
		return vim.ui.select(...)
	end

	---@diagnostic disable-next-line: duplicate-set-field
	vim.ui.input = function(...)
		require("lazy").load({ plugins = { "dressing.nvim" } })
		return vim.ui.input(...)
	end
end

return M
