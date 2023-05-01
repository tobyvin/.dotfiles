require("tobyvin.options")
require("tobyvin.keymaps")
require("tobyvin.lsp")
require("tobyvin.lazy")
require("tobyvin.utils.dashboard")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("tobyvin.autocmds")
		require("tobyvin.diagnostic")
		require("tobyvin.utils.session").setup()
	end,
})
