local themes = require("telescope.themes")
local backends = require("dressing.config").get_mod_config("select").backend
local M = {}

M.kinds = {
	select = {
		select_normal = {
			telescope = themes.get_dropdown({ initial_mode = "normal" }),
		},
	},
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
				if vim.tbl_contains(M.kinds, opts.kind) then
					return M.kinds.select[opts.kind]
				elseif vim.tbl_contains(backends, opts.kind) then
					return { backend = opts.kind }
				end
			end,
		},
	})
end

return M
