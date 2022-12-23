require("tobyvin.options")
require("tobyvin.lazy")

vim.cmd([[colorscheme gruvbox]])

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("tobyvin.autocmds")
		require("tobyvin.keymaps")
		require("tobyvin.diagnostic")
		require("tobyvin.lsp")
	end,
})
