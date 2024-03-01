vim.opt_local.textwidth = 80
vim.g.markdown_recommended_style = 0
vim.bo.shiftwidth = 2

local function toggle_checkbox()
	local node = vim.treesitter.get_node()

	if node and not node:type():match("task_list_marker_(u?n?checked)") then
		while node ~= nil and node:type() ~= "list_item" do
			node = node:parent()
		end

		if node == nil or node:type() ~= "list_item" then
			return false
		end

		node = vim.iter(node:iter_children()):find(function(child)
			return child:type():match("task_list_marker_u?n?checked") ~= nil
		end)
	end

	local content
	if node == nil then
		return
	elseif node:type() == "task_list_marker_checked" then
		content = { "[ ]" }
	elseif node:type() == "task_list_marker_unchecked" then
		content = { "[x]" }
	end

	local sr, sc, er, ec = node:range()
	vim.api.nvim_buf_set_text(0, sr, sc, er, ec, content)
end

vim.keymap.set({ "n" }, "<leader><leader>", toggle_checkbox, {
	buffer = 0,
	desc = "toggle checkbox",
})
