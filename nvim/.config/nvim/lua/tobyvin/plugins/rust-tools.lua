local utils = require("tobyvin.utils")
local lsp = require("tobyvin.lsp")
local M = {
	codelldb = "/usr/lib/codelldb/adapter/codelldb",
	liblldb = "/usr/lib/codelldb/lldb/lib/liblldb.so",
}

M.dap_adapter = function()
	if vim.fn.executable(M.codelldb) ~= 0 then
		return {
			adapter = require("rust-tools.dap").get_codelldb_adapter(M.codelldb, M.liblldb),
		}
	end
	vim.notify("Failed to find codelldb adapter")
end

M.setup = function()
	local status_ok, rust_tools = pcall(require, "rust-tools")
	if not status_ok then
		vim.notify("Failed to load module 'rust-tools'", "error")
		return
	end

	rust_tools.setup({
		-- tools = {
		-- 	autoSetHints = true,
		-- 	hover_with_actions = true,
		-- 	runnables = {
		-- 		use_telescope = true,
		-- 	},
		-- 	inlay_hints = {
		-- 		show_parameter_hints = true,
		-- 		parameter_hints_prefix = "",
		-- 		other_hints_prefix = "",
		-- 	},
		-- },
		server = lsp.config({
			standalone = true,
			settings = {
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
					},
					checkOnSave = {
						command = "clippy",
					},
				},
			},
			on_attach = function(client, bufnr)
				if vim.fn.executable(M.codelldb) == 0 then
					vim.notify(
						"[DAP] Failed to find codelldb, falling back to default DAP adapter.",
						"warn",
						{ title = "[rust-tools] codelldb not found" }
					)
				end
				vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
				vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
				lsp.on_attach(client, bufnr)

				local nmap = utils.create_map_group("n", "<leader>", { buffer = bufnr })
				nmap("dd", rust_tools.debuggables.debuggables, { desc = "Debug" })
				nmap("tt", rust_tools.runnables.runnables, { desc = "Run" })
				-- nmap("lh", rust_tools.hover_actions.hover_actions, { desc = "Hover Actions" })
				-- nmap("la", rust_tools.code_action_group.code_action_group, { desc = "Code Actions" })
			end,
		}),
		dap = M.dap_adapter(),
	})
end

return M
