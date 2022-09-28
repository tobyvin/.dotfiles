local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, crates = pcall(require, "crates")
	if not status_ok then
		vim.notify("Failed to load module 'crates'", "error")
		return
	end

	crates.setup({
		null_ls = {
			enabled = true,
		},
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		pattern = "*/Cargo.toml",
		callback = function()
			utils.documentation.register("toml", crates.open_documentation)

			-- TODO: impl registration system like documentation (global and buffer?)
			local original = vim.lsp.handlers["textDocument/hover"]
			vim.lsp.handlers["textDocument/hover"] = function(...)
				if crates.popup_available() then
					crates.show_popup()
				else
					original(...)
				end
			end
		end,
	})
end

return M
