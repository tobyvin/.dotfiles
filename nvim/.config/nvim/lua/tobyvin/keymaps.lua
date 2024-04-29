vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "cnext" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "cprev" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "bnext" })
vim.keymap.set("n", "[b", "<cmd>bprev<cr>", { desc = "bprev" })

vim.keymap.set("n", "gl", vim.diagnostic.setloclist, { desc = "vim.diagnostic.setloclist()" })
vim.keymap.set("n", "gL", vim.diagnostic.setqflist, { desc = "vim.diagnostic.setqflist()" })

vim.keymap.set("n", "<a-k>", ":move --<cr>==", { desc = "move --" })
vim.keymap.set("n", "<a-j>", ":move +<cr>==", { desc = "move +" })
vim.keymap.set("v", "<a-k>", ":move '<-2<cr>gv=gv", { desc = "move --" })
vim.keymap.set("v", "<a-j>", ":move '>+1<cr>gv=gv", { desc = "move +" })

vim.keymap.set("t", "<c-w>", [[<c-\><c-n><c-w>]], { desc = "CTRL-W" })

vim.keymap.set("o", "o", function()
	local cursor = vim.fn.winsaveview()
	vim.cmd.normal({ "ggVG", bang = true, mods = { keepjumps = true } })
	if cursor and not string.find(vim.v.operator, "[cd]") then
		vim.defer_fn(function()
			vim.fn.winrestview(cursor)
		end, 0)
	end
end, { desc = "buffer text object" })

vim.keymap.set("i", "<cr>", function()
	return vim.fn.pumvisible() == 1 and "<C-y>" or "<cr>"
end, { expr = true, noremap = true })

vim.keymap.set({ "i", "s" }, "<tab>", function()
	return vim.snippet.jumpable(1) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<tab>"
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<s-tab>", function()
	return vim.snippet.jumpable(-1) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<s-tab>"
end, { expr = true })
