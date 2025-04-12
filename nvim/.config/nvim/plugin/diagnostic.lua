vim.diagnostic.config({
	underline = true,
	virtual_text = {
		source = "if_many",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
	float = {
		scope = "cursor",
		source = true,
		border = "single",
	},
	update_in_insert = true,
	severity_sort = true,
})

vim.keymap.set("n", "gl", function()
	vim.diagnostic.setloclist()
	local loclist = vim.fn.getloclist(0, { winid = true, size = true })
	if loclist.winid ~= 0 and loclist.size < 10 then
		vim.api.nvim_win_set_height(loclist.winid, loclist.size)
	end
end, { desc = "vim.diagnostic.setloclist()" })

vim.keymap.set("n", "gL", function()
	vim.diagnostic.setqflist()
	local qflist = vim.fn.getqflist({ winid = true, size = true })
	if qflist.winid ~= 0 and qflist.size < 10 then
		vim.api.nvim_win_set_height(qflist.winid, qflist.size)
	end
end, { desc = "vim.diagnostic.setqflist()" })
