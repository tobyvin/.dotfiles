local hover = function()
	if require("tobyvin.utils.hover").open() then
		-- Fix for diagnostics immediately overriding hover window
		vim.api.nvim_command("set eventignore=CursorHold")
		vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
		return "<Ignore>"
	end
	return "K"
end

local external_docs = function()
	if require("tobyvin.utils.documentation").open() then
		return "<Ignore>"
	end
	return "gx"
end

vim.keymap.set("n", "gx", external_docs, { desc = "external_docs", expr = true })
vim.keymap.set("n", "K", hover, { expr = true, desc = "hover" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "up half page and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "down half page and center" })
vim.keymap.set("n", "<a-j>", "<CMD>m +1<CR>", { desc = "move line down" })
vim.keymap.set("n", "<a-k>", "<CMD>m -2<CR>", { desc = "move line up" })
vim.keymap.set("v", "<a-k>", "<CMD>m '<-2<CR>gv=gv", { desc = "move selection up" })
vim.keymap.set("v", "<a-j>", "<CMD>m '>+1<CR>gv=gv", { desc = "move selection down" })
