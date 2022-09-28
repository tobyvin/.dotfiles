local M = {}

M.groups = {}

--- Helper function to create a group of keymaps that share a common prefix and/or options.
---@param mode string|table Same mode short names as vim.keymap.set(). A list will create the group on all modes.
---@param group_lhs string Prefix to prepend to the lhs of all keymaps in the group.
---@param group_opts ?table Options to apply to all keymaps in this group. (Same as options listed in vim.keymap.set)
---@return function Function to create mapping using the groups defaults.
-- TODO: Possibly add memoization to groups/subgroups using the __call metatable attribute
M.group = function(mode, group_lhs, group_opts)
	group_opts = group_opts or {}

	for _, m in pairs(vim.tbl_flatten({ mode })) do
		M.groups[m] = M.groups[m] == nil and {} or M.groups[m]
		M.groups[m][group_lhs] = group_opts
	end

	local desc = group_opts.desc
	group_opts.desc = nil

	local status_ok, which_key = pcall(require, "which-key")
	if status_ok and desc ~= nil then
		for _, m in pairs(vim.tbl_flatten({ mode })) do
			which_key.register({ [group_lhs] = { name = desc } }, vim.tbl_extend("force", { mode = m }, group_opts))
		end
	end

	return function(lhs, rhs, opts)
		vim.keymap.set(mode, group_lhs .. lhs, rhs, vim.tbl_deep_extend("keep", opts or {}, group_opts))
	end
end

return M
