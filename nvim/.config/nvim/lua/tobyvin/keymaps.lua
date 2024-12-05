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

vim.keymap.set("i", "<cr>", function()
	return vim.fn.pumvisible() == 1 and "<C-y>" or "<cr>"
end, { expr = true, noremap = true })

vim.keymap.set({ "i", "s" }, "<tab>", function()
	if vim.snippet.active({ direction = 1 }) then
		return "<cmd>lua vim.snippet.jump(1)<cr>"
	else
		return "<tab>"
	end
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<s-tab>", function()
	if vim.snippet.active({ direction = -1 }) then
		return "<cmd>lua vim.snippet.jump(-1)<cr>"
	else
		return "<s-tab>"
	end
end, { expr = true })

vim.keymap.set("o", "o", function()
	local vl = vim.api.nvim_buf_get_mark(0, "<")
	local vr = vim.api.nvim_buf_get_mark(0, ">")
	local cursor = vim.fn.winsaveview()
	vim.cmd.normal({ "ggVG", bang = true, mods = { keepjumps = true } })
	vim.schedule(function()
		vim.fn.winrestview(cursor)
		local _, max_lnum = unpack(vim.fn.getpos("$"))
		vim.api.nvim_buf_set_mark(0, "<", math.min(vl[1], max_lnum), vl[2], {})
		vim.api.nvim_buf_set_mark(0, ">", math.min(vr[1], max_lnum), vr[2], {})
	end)
end, { desc = "buffer text object" })

-- TODO: remove once default binds are on stable
-- Ref: https://github.com/neovim/neovim/issues/28634 (old)
-- Ref: https://github.com/neovim/neovim/pull/28649 (old)
-- Ref: https://github.com/neovim/neovim/pull/28650
-- Source: https://github.com/neovim/neovim/blob/fd902b1cb2463e220e5bd5fe37a0cfdd259ff35a/runtime/lua/vim/_defaults.lua#L161C1-L185C6
--- Default maps for LSP functions.
---
--- These are mapped unconditionally to avoid different behavior depending on whether an LSP
--- client is attached. If no client is attached, or if a server does not support a capability, an
--- error message is displayed rather than exhibiting different behavior.
---
--- See |grr|, |grn|, |gra|, |gri|, |gO|, |i_CTRL-S|.
do
	vim.keymap.set("n", "grn", function()
		vim.lsp.buf.rename()
	end, { desc = "vim.lsp.buf.rename()" })

	vim.keymap.set({ "n", "x" }, "gra", function()
		vim.lsp.buf.code_action()
	end, { desc = "vim.lsp.buf.code_action()" })

	vim.keymap.set("n", "grr", function()
		vim.lsp.buf.references()
	end, { desc = "vim.lsp.buf.references()" })

	vim.keymap.set("n", "gri", function()
		vim.lsp.buf.implementation()
	end, { desc = "vim.lsp.buf.implementation()" })

	vim.keymap.set("n", "gO", function()
		vim.lsp.buf.document_symbol()
	end, { desc = "vim.lsp.buf.document_symbol()" })

	vim.keymap.set({ "i", "s" }, "<C-S>", function()
		vim.lsp.buf.signature_help()
	end, { desc = "vim.lsp.buf.signature_help()" })
end
