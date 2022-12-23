local M = {
	"stevearc/dressing.nvim",
	lazy = true,
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
}

function M.config()
	local dressing = require("dressing")

	local format_item_override = {
		["rust-tools/debuggables"] = function(item)
			item = item:gsub(" %-%-no%-run", "")
			item = item:gsub(" %-%-package", " -p")
			item = item:gsub(" %-%-all%-features", "")
			item = item:gsub(" %-%-all%-targets", "")
			item = item:gsub(" %-%-exact", "")
			item = item:gsub(" %-%-nocapture", "")
			return item
		end,
	}

	local config_overrides = {
		select = {
			["Ring history"] = {
				telescope = require("telescope.themes").get_dropdown({ preview = true }),
			},
		},
		input = {
			cmd = {
				relative = "win",
				insert_only = false,
			},
		},
	}

	dressing.setup({
		input = {
			get_config = function(opts)
				local overrides = config_overrides.input

				if overrides[opts.kind] ~= nil then
					return overrides[opts.kind]
				elseif overrides[opts.prompt] ~= nil then
					return overrides[opts.prompt]
				end
			end,
		},
		select = {
			get_config = function(opts)
				local overrides = config_overrides.select

				if overrides[opts.kind] ~= nil then
					return overrides[opts.kind]
				elseif overrides[opts.prompt] ~= nil then
					return overrides[opts.prompt]
				end
			end,
			format_item_override = format_item_override,
		},
	})
end

return M
