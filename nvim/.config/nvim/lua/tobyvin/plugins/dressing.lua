local themes = require("telescope.themes")
local backends = require("dressing.config").get_mod_config("select").backend
local M = {}

M.kinds = {
	select = {
		select_normal = {
			telescope = themes.get_dropdown({ initial_mode = "normal" }),
		},
	},
	input = {
		cargo = {
			relative = "win",
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
		input = {
			get_config = function(opts)
				if vim.startswith(opts.prompt, "cargo") then
					return {
						relative = "win",
					}
				end
			end,
		},
		select = {
			get_config = function(opts)
				if vim.tbl_contains(vim.tbl_keys(M.kinds.select), opts.kind) then
					return M.kinds.select[opts.kind]
				elseif vim.tbl_contains(backends, opts.kind) then
					return { backend = opts.kind }
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
	})
end

return M
