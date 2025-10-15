vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if vim.treesitter.language.add(lang or "") then
			vim.treesitter.start(args.buf, lang)
			if #vim.api.nvim_get_runtime_file(("queries/%s/folds.scm"):format(lang), false) > 0 then
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end
		end
	end,
})
