local M = {
	"saecki/crates.nvim",
	event = "BufRead Cargo.toml",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"jose-elias-alvarez/null-ls.nvim",
	},
}

function M.config()
	local crates = require("crates")

	local utils = require("tobyvin.utils")

	crates.setup({
		null_ls = {
			enabled = true,
		},
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("tobyvin_crates", { clear = true }),
		pattern = "*/Cargo.toml",
		desc = "setup crates",
		callback = function(args)
			utils.documentation.register("toml", crates.open_documentation)
			utils.hover.register(crates.show_popup, {
				enabled = crates.popup_available,
				desc = "crates",
				buffer = args.buf,
				priority = 10,
			})
		end,
	})
end

return M
