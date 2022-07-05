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
end

M.setup = function()
	local status_ok, rust_tools = pcall(require, "rust-tools")
	if not status_ok then
		vim.notify("Failed to load module 'rust-tools'", "error")
		return
	end

	rust_tools.setup({
		tools = {
			autoSetHints = true,
			hover_with_actions = true,
			runnables = {
				use_telescope = true,
			},
			inlay_hints = {
				show_parameter_hints = true,
				parameter_hints_prefix = "",
				other_hints_prefix = "",
			},
		},
		server = lsp.config({
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
				lsp.on_attach(client, bufnr)
			end,
		}),
		dap = M.dap_adapter(),
	})
end

return M
