local M = {}

M.setup = function()
	local status_ok, lint = pcall(require, "lint")
	if not status_ok then
		vim.notify("Failed to load module 'lint'", "error")
		return
	end

	lint.linters_by_ft = {
		markdown = { "vale" },
		python = { "pylint" },
	}

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			lint.try_lint()
		end,
	})
end

return M
