local M = {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		"folke/neodev.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
}

function M.config()
	local lspconfig = require("lspconfig")
	local configs = require("tobyvin.lsp.configs")

	require("mason")

	require("lspconfig.ui.windows").default_options.border = "single"

	lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	})

	local available = lspconfig.util.available_servers()
	for name, config in pairs(configs) do
		if not vim.tbl_contains(available, name) then
			lspconfig[name].setup(config)
		end
	end

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("tobyvin_lsp_config", { clear = true }),
		desc = "lsp",
		callback = function(args)
			local lspinfo = require("lspconfig.ui.lspinfo")
			vim.keymap.set("n", "<leader>li", lspinfo, { desc = "lsp info", buffer = args.buf })
		end,
	})
end

return M