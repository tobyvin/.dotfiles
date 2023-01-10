require("tobyvin.options")
require("tobyvin.keymaps")
require("tobyvin.lazy")
require("tobyvin.utils.start")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("tobyvin.autocmds")
		require("tobyvin.diagnostic")
		require("tobyvin.lsp")
	end,
})
