local nvim_treesitter = require("nvim-treesitter")

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if vim.treesitter.language.add(lang or "") then
			if #vim.api.nvim_get_runtime_file(("queries/%s/indents.scm"):format(lang), false) > 0 then
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end
	end,
})

-- TODO: Install just hangs when tree-sitter CLI is not installed
-- See: https://github.com/nvim-treesitter/nvim-treesitter/issues/8010
if vim.fn.executable("tree-sitter") == 0 then
	local install = nvim_treesitter.install({
		"bash",
		"cmake",
		"cpp",
		"c_sharp",
		"css",
		"comment",
		"diff",
		"gitignore",
		"go",
		"graphql",
		"html",
		"java",
		"javascript",
		"jsdoc",
		"jsonc",
		"json",
		"latex",
		"make",
		"python",
		"regex",
		"ron",
		"rust",
		"scss",
		"sql",
		"svelte",
		"toml",
		"tsx",
		"typescript",
		"typst",
		"vue",
		"yaml",
		"zig",
	})

	if #vim.api.nvim_list_uis() == 0 then
		install:wait(300000)
	end
end
