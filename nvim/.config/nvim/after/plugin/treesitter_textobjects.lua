local success, nvim_treesitter_textobjects = pcall(require, "nvim-treesitter-textobjects")
if not success then
	return
end

nvim_treesitter_textobjects.setup({
	select = {
		lookahead = true,
	},
})

local function move_map(lhs, fn, obj)
	vim.keymap.set({ "n", "x", "o" }, lhs, function()
		require("nvim-treesitter-textobjects.move")[fn](obj, "textobjects")
	end)
end

local function select_map(lhs, obj, scope)
	vim.keymap.set({ "x", "o" }, lhs, function()
		require("nvim-treesitter-textobjects.select").select_textobject(obj, scope or "textobjects")
	end)
end

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if vim.treesitter.language.add(lang or "") then
			if #vim.api.nvim_get_runtime_file(("queries/%s/textobjects.scm"):format(lang), false) > 0 then
				move_map("]m", "goto_next_start", "@function.outer")
				move_map("]]", "goto_next_start", "@class.outer")
				move_map("]M", "goto_next_end", "@function.outer")
				move_map("][", "goto_next_end", "@class.outer")
				move_map("[m", "goto_previous_start", "@function.outer")
				move_map("[[", "goto_previous_start", "@class.outer")
				move_map("[M", "goto_previous_end", "@function.outer")
				move_map("[]", "goto_previous_end", "@class.outer")
				select_map("ib", "@block.inner")
				select_map("ab", "@block.outer")
				select_map("ie", "@call.inner")
				select_map("ae", "@call.outer")
				select_map("ic", "@class.inner")
				select_map("ac", "@class.outer")
				select_map("ii", "@conditional.inner")
				select_map("ai", "@conditional.outer")
				select_map("if", "@function.inner")
				select_map("af", "@function.outer")
				select_map("il", "@loop.inner")
				select_map("al", "@loop.outer")
				select_map("ia", "@parameter.inner")
				select_map("aa", "@parameter.outer")
				select_map("iv", "@statement.inner")
				select_map("av", "@statement.outer")
				select_map("as", "@local.scope", "locals")
			end
		end
	end,
})
