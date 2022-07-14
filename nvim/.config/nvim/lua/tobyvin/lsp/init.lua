local M = {}

M.on_attach = function(client, bufnr)
	vim.keymap.set("n", "<C-Space>", vim.lsp.buf.code_action, { desc = "Code Action" })
	local nmap = require("tobyvin.utils").create_map_group("n", "<leader>l", { name = "LSP", buffer = bufnr })

	nmap("a", vim.lsp.buf.code_action, { desc = "Code Action" })
	nmap("d", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document Diagnostics" })
	nmap("D", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Diagnostics" })
	nmap("h", vim.lsp.buf.hover, { desc = "Hover" })
	nmap("H", vim.lsp.buf.signature_help, { desc = "Signature Help" })
	nmap("j", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
	nmap("k", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
	nmap("l", vim.lsp.codelens.run, { desc = "CodeLens Action" })
	nmap("o", "<cmd>SymbolsOutline<cr>", { desc = "Outline" })
	-- nmap("q", vim.lsp.diagnostic.setloclist, { desc = "Quickfix" })
	nmap("r", vim.lsp.buf.rename, { desc = "Rename" })
	nmap("R", "<cmd>TroubleToggle lsp_references<cr>", { desc = "References" })
	nmap("s", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
	nmap("S", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Workspace Symbols" })
	nmap("w", "<cmd>Telescope lsp_workspace_diagnostics<cr>", { desc = "Workspace Diagnostics" })

	local nmap_goto = require("tobyvin.utils").create_map_group("n", "<leader>lg", { name = "Goto", buffer = bufnr })
	nmap_goto("d", vim.lsp.buf.definition, { desc = "Definition" })
	nmap_goto("D", vim.lsp.buf.declaration, { desc = "Declaration" })
	nmap_goto("i", vim.lsp.buf.implementation, { desc = "Implementation" })
	nmap_goto("r", vim.lsp.buf.references, { desc = "References" })

	-- disabled in favor of https://github.com/nvim-treesitter/nvim-treesitter-refactor#highlight-definitions
	-- require("tobyvin.lsp.highlighting").on_attach(client, bufnr)
	require("tobyvin.lsp.formatting").on_attach(client, bufnr)
	require("tobyvin.lsp.symbol").on_attach(client, bufnr)
	require("lsp_signature").on_attach()
end

M.config = function(config)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

	return vim.tbl_deep_extend("keep", config or {}, {
		capabilities = capabilities,
		on_attach = M.on_attach,
	})
end

M.setup = function()
	require("tobyvin.lsp.handlers").setup()
end

return M
