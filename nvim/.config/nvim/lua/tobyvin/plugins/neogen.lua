local M = {}

M.setup = function()
	local status_ok, neogen = pcall(require, "neogen")
	if not status_ok then
		vim.notify("Failed to load module 'neogen'", "error")
		return
	end

	local nmap = require("tobyvin.utils").create_map_group("n", "<leader>s", { name = "Snippets" })

	neogen.setup({ snippet_engine = "luasnip" })

	nmap("d", neogen.generate)
end

return M
