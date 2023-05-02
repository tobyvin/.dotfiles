require("tobyvin.options")
require("tobyvin.filetype")
require("tobyvin.autocmds")
require("tobyvin.keymaps")
require("tobyvin.lsp")
require("tobyvin.lazy")
require("tobyvin.utils.dashboard")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("tobyvin.diagnostic")
	end,
})
