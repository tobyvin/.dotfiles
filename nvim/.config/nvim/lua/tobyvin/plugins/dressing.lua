local themes = require("telescope.themes")
local M = {}

M.format_item_override = {
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

M.config_overrides = {
	select = {
		["Ring history"] = {
			telescope = themes.get_dropdown({ preview = true }),
		},
	},
	input = {
		cmd = {
			relative = "win",
			insert_only = false,
		},
	},
}

M.get_config = function(type, opts)
	local overrides = M.config_overrides[type]

	if overrides[opts.kind] ~= nil then
		return overrides[opts.kind]
	elseif overrides[opts.prompt] ~= nil then
		return overrides[opts.prompt]
	end
end

M.setup = function()
	local status_ok, dressing = pcall(require, "dressing")
	if not status_ok then
		vim.notify("Failed to load module 'dressing'", vim.log.levels.ERROR)
		return
	end

	dressing.setup({
		input = {
			get_config = function(opts)
				local overrides = M.config_overrides.input

				if overrides[opts.kind] ~= nil then
					return overrides[opts.kind]
				elseif overrides[opts.prompt] ~= nil then
					return overrides[opts.prompt]
				end
			end,
		},
		select = {
			get_config = function(opts)
				local overrides = M.config_overrides.select

				if overrides[opts.kind] ~= nil then
					return overrides[opts.kind]
				elseif overrides[opts.prompt] ~= nil then
					return overrides[opts.prompt]
				end
			end,
			format_item_override = M.format_item_override,
		},
	})
end

return M
