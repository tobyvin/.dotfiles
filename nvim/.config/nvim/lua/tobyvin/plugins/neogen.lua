local M = {}

M.setup = function()
	local status_ok, neogen = pcall(require, "neogen")
	if not status_ok then
		vim.notify("Failed to load module 'neogen'", vim.log.levels.ERROR)
		return
	end

	local nmap = require("tobyvin.utils").keymap.group("n", "<leader>s", { desc = "Snippets" })

	neogen.setup({ snippet_engine = "luasnip" })

	nmap("d", neogen.generate)
end

return M
