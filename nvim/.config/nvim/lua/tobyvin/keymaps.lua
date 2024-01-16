vim.keymap.set("n", "]]", "<CMD>cnext<CR>", { desc = "go to next error" })
vim.keymap.set("n", "[[", "<CMD>cprev<CR>", { desc = "go to previous error" })
vim.keymap.set("n", "]b", "<CMD>bnext<CR>", { desc = "go to next buffer in the buffer list" })
vim.keymap.set("n", "[b", "<CMD>bprev<CR>", { desc = "go to previous buffer in the buffer list" })
vim.keymap.set("n", "]g", vim.diagnostic.goto_next, { desc = "add buffer diagnostics to loclist" })
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, { desc = "add buffer diagnostics to loclist" })

vim.keymap.set("n", "gl", vim.diagnostic.setloclist, { desc = "add buffer diagnostics to loclist" })
vim.keymap.set("n", "gL", vim.diagnostic.setqflist, { desc = "add all diagnostics to qflist" })
vim.keymap.set("n", "L", vim.diagnostic.open_float, { desc = "show diagnostics in floating window" })

vim.keymap.set("n", "<a-j>", "<CMD>m +1<CR>", { desc = "move line down" })
vim.keymap.set("n", "<a-k>", "<CMD>m -2<CR>", { desc = "move line up" })
vim.keymap.set("v", "<a-k>", "<CMD>m '<-2<CR>gv=gv", { desc = "move selection up" })
vim.keymap.set("v", "<a-j>", "<CMD>m '>+1<CR>gv=gv", { desc = "move selection down" })

vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { desc = "CTRL-W" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "yank lines into selection register" })
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]], { desc = "yank lines into selection register" })
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "put lines from selection register" })
vim.keymap.set({ "n", "v" }, "<leader>P", [["+P]], { desc = "put lines from selection register" })

vim.keymap.set("o", "o", function()
	local cursor = vim.fn.winsaveview()
	vim.cmd.normal({ "ggVG", bang = true, mods = { keepjumps = true } })
	if cursor and not string.find(vim.v.operator, "[cd]") then
		vim.defer_fn(function()
			vim.fn.winrestview(cursor)
		end, 0)
	end
end, { desc = "buffer text object" })

vim.keymap.set({ "i", "s" }, "<Tab>", function()
	return vim.snippet.jumpable(1) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	return vim.snippet.jumpable(-1) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<Tab>"
end, { expr = true })
