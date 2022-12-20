local M = {
	"SmiteshP/nvim-navic",
	dependencies = { "onsails/lspkind-nvim" },
}

function M.config()
	local nvim_navic = require("nvim-navic")

	local icons = require("lspkind").symbol_map
	for i, _ in pairs(icons) do
		icons[i] = icons[i] .. " "
	end

	nvim_navic.setup({
		icons = icons,
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("tobyvin_nvim-navic", { clear = true }),
		desc = "setup nvim-navic",
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)

			if client.name ~= "cssls" and client.server_capabilities.documentSymbolProvider then
				require("nvim-navic").attach(client, bufnr)
			end
		end,
	})
end

return M
