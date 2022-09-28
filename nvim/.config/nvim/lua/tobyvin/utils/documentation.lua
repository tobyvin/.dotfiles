local M = {}

M.sources = {
	vim = function()
		vim.cmd("help " .. vim.fn.expand("<cword>"))
	end,
	help = function()
		vim.cmd("Man " .. vim.fn.expand("<cword>"))
	end,
}

M.register = function(filetypes, callback)
	for _, filetype in ipairs(vim.tbl_flatten({ filetypes })) do
		M.sources[filetype] = callback
	end
end

M.open = function()
	local filetype = vim.bo.filetype
	if vim.tbl_contains(vim.tbl_keys(M.sources), filetype) then
		M.sources[filetype]()
	else
		vim.notify("[Utils] Documentation not available", vim.log.levels.ERROR)
	end
end

return M
