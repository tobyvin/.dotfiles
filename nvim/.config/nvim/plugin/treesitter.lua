vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if vim.treesitter.language.add(lang or "") then
			vim.treesitter.start(args.buf, lang)
			vim.iter(vim.api.nvim_get_runtime_file(("queries/%s/*.scm"):format(lang), false))
				:map(vim.fs.basename)
				:each(function(query)
					if query == "folds.scm" then
						vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
					elseif query == "indents.scm" then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end)
		end
	end,
})
