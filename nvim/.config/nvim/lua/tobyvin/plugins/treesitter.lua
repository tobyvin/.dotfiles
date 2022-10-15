local M = {}

M.attached_keymaps = {}

M.setup = function()
	local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
	if not status_ok then
		vim.notify("Failed to load module 'nvim-treesitter'", vim.log.levels.ERROR)
		return
	end

	local queries = require("nvim-treesitter.query")

	treesitter.define_modules({
		tobyvin_keymaps = {
			attach = function(bufnr, _)
				local refactor_module = require("nvim-treesitter-refactor.smart_rename")
				local smart_rename = function()
					refactor_module.smart_rename(bufnr)
				end

				vim.keymap.set("n", "<leader>lr", smart_rename, { desc = "Rename", buffer = bufnr })
				M.attached_keymaps[bufnr] = { "n", "<leader>lr", { buffer = bufnr } }
			end,
			detach = function(bufnr)
				local attached_keymaps = vim.F.if_nil(M.attached_keymaps[bufnr], {})
				for _, attached_keymap in pairs(attached_keymaps) do
					vim.keymap.del(unpack(attached_keymap))
				end
			end,
			is_supported = function(lang)
				return queries.has_locals(lang)
			end,
		},
	})

	treesitter.setup({
		ensure_installed = "all",
		tobyvin_keymaps = {
			enable = true,
		},
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
		incremental_selection = {
			enable = true,
			keymaps = {
				node_incremental = "<TAB>",
				node_decremental = "<S-TAB>",
			},
		},
		refactor = {
			smart_rename = {
				enable = true,
			},
		},
		playground = {
			enable = true,
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ia"] = "@statement.inner",
					["aa"] = "@statement.outer",
					["il"] = "@loop.inner",
					["al"] = "@loop.outer",
					["ib"] = "@block.inner",
					["ab"] = "@block.outer",
					["ic"] = "@class.inner",
					["ac"] = "@class.outer",
					["a/"] = "@comment.outer",
					["ii"] = "@conditional.inner",
					["ai"] = "@conditional.outer",
					["iv"] = "@parameter.inner",
					["av"] = "@parameter.outer",
				},
			},
		},
		textsubjects = {
			enable = true,
			prev_selection = ",", -- (Optional) keymap to select the previous selection
			keymaps = {
				["."] = "textsubjects-smart",
				["a."] = "textsubjects-container-outer",
				["i."] = "textsubjects-container-inner",
			},
		},
	})
end

return M
