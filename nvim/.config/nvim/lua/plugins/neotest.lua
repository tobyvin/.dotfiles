---@type LazySpec
local neotest = {
	"nvim-neotest/neotest",
	dependencies = {},
}

function neotest:opts(opts)
	return vim.tbl_extend("keep", opts, {
		adapters = {
			require("neotest-go"),
			require("neotest-plenary"),
			require("neotest-python")({ dap = { justMyCode = false } }),
			require("neotest-rust"),
		},
	})
end

function neotest:init()
	vim.keymap.set("n", "<leader>tt", function()
		require("neotest").run.run({ suite = false, strategy = "integrated" })
	end, { desc = "run nearest test" })
	vim.keymap.set("n", "<leader>td", function()
		require("neotest").run.run({ suite = false, strategy = "dap" })
	end, { desc = "debug nearest test" })
end

---@type LazySpec
local M = {
	"nvim-neotest/nvim-nio",
	"nvim-lua/plenary.nvim",
	"nvim-neotest/neotest-go",
	"nvim-neotest/neotest-plenary",
	"nvim-neotest/neotest-python",
	"rouge8/neotest-rust",
	"nvim-treesitter/nvim-treesitter",
	neotest,
}

return M
