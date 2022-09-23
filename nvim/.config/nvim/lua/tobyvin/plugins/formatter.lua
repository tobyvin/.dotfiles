local M = {}

M.setup = function()
	local status_ok, formatter = pcall(require, "formatter")
	if not status_ok then
		vim.notify("Failed to load module 'formatter'", "error")
		return
	end

	formatter.setup({
		filetype = {
			lua = {
				require("formatter.filetypes.lua").stylua,
			},
			sh = {
				require("formatter.filetypes.sh").shfmt,
			},
			javascript = {
				require("formatter.filetypes.javascript").prettier,
			},
			markdown = {
				require("formatter.filetypes.markdown").prettier,
			},
			python = {
				require("formatter.filetypes.python").black,
			},
			["*"] = {
				require("formatter.filetypes.any").remove_trailing_whitespace,
			},
		},
	})

  vim.keymap.set("n", "<leader>lf", "<CMD>Format<CR>", { desc = "Format" })
  vim.keymap.set("n", "<leader>lF", "<CMD>FormatWrite<CR>", { desc = "Format Write" })
end

return M
