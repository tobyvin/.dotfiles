local M = {}

M._dap_adapter = function()
	local ext_path = vim.env.HOME .. "/usr/lib/codelldb/"
	local codelldb_path = ext_path .. "adapter/codelldb"
	local liblldb_path = ext_path .. "lldb/lib/liblldb.so"

	if not require("tobyvin.utils").isdir(ext_path) then
		vim.notify(
			"[DAP] Failed to find codelldb, falling back to default DAP adapter.",
			"warn",
			{ title = "[rust-tools] codelldb not found" }
		)
		return {}
	end

	return {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	}
end

M.setup = function()
	local status_ok, rust_tools = pcall(require, "rust-tools")
	if not status_ok then
		vim.notify("Failed to load module 'rust-tools'", "error")
		return
	end

	local lsp = require("tobyvin.lsp")

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
		}),
		dap = M._dap_adapter(),
	})
end

return M
