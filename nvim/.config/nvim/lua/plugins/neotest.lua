local utils = require("tobyvin.utils")

---@type LazyPluginSpec
local M = {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"rouge8/neotest-rust",
	},
}

function M:init()
	utils.on_attach(function()
		vim.keymap.set("n", "<leader>tt", function()
			require("neotest").run.run()
		end, { desc = "run nearest test" })
	end, { name = "rust_analyzer" })
end

function M:config(opts)
	opts.adapters = {
		require("neotest-rust"),
	}

	require("neotest").setup(opts)
end

return M
