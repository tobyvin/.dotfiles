local M = {}

M.attached_keymaps = {}

M.setup = function()
	local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
	if not status_ok then
		vim.notify("Failed to load module 'nvim-treesitter'", vim.log.levels.ERROR)
		return
	end

	treesitter.setup({
		ensure_installed = "all",
		indent = {
			enable = true,
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "markdown" },
			disable = function(_, bufnr)
				-- TODO: temp solution to ts highlighting screwing up formatting
				return vim.api.nvim_buf_line_count(bufnr) > 2500 or vim.bo[bufnr].filetype == "help"
			end,
		},
		playground = {
			enable = true,
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["ia"] = "@attribute.inner",
					["aa"] = "@attribute.outer",
					["ib"] = "@block.inner",
					["ab"] = "@block.outer",
					["ic"] = "@class.inner",
					["ac"] = "@class.outer",
					["ie"] = "@statement.inner",
					["ae"] = "@statement.outer",
					["if"] = "@function.inner",
					["af"] = "@function.outer",
					["iF"] = "@frame.inner",
					["aF"] = "@frame.outer",
					["ii"] = "@conditional.inner",
					["ai"] = "@conditional.outer",
					["il"] = "@loop.inner",
					["al"] = "@loop.outer",
					["in"] = "@scopename.inner",
					["an"] = "@scopename.outer",
					["ix"] = "@call.inner",
					["ax"] = "@call.outer",
					["iv"] = "@parameter.inner",
					["av"] = "@parameter.outer",
					["i/"] = "@comment.inner",
					["a/"] = "@comment.outer",
				},
			},
		},
		context_commentstring = {
			enable = true,
		},
	})
end

return M
