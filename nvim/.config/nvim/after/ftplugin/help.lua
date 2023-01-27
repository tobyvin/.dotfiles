local win = vim.fn.win_getid(vim.fn.winnr("#"))
local buf = vim.api.nvim_win_get_buf(win)

if vim.api.nvim_win_get_width(win) >= vim.bo[buf].textwidth + 80 then
	vim.cmd.wincmd("L")
end

vim.opt_local.colorcolumn = nil
