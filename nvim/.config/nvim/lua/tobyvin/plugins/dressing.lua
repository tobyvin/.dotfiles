local themes = require("telescope.themes")
local M = {}

M.get_mt = function(kind)
	return {
		__index = function(v)
			local backends = require("dressing.config").get_mod_config(kind).backend
			if vim.tbl_contains(backends, v) then
				return { backend = v }
			end
		end,
	}
end

M.kinds = {
	select = setmetatable({
		select_normal = {
			telescope = themes.get_dropdown({ initial_mode = "normal" }),
		},
	}, M.get_mt("input")),
	input = setmetatable({}, M.get_mt("input")),
}

M.setup = function()
	local status_ok, dressing = pcall(require, "dressing")
	if not status_ok then
		vim.notify("Failed to load module 'dressing'", "error")
		return
	end

	dressing.setup({
		select = {
			get_config = function(opts)
				return M.kinds.select[opts.kind]
			end,
		},
	})
end

return M
