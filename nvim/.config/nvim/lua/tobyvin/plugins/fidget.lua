local M = {
	"j-hui/fidget.nvim",
}

function M.config()
	local fidget = require("fidget")
	local utils = require("tobyvin.utils")

	fidget.setup({
		text = {
			spinner = utils.status.signs.spinner.text,
			done = vim.trim(utils.status.signs.completed.text),
		},
		window = { blend = 0 },
	})
end

return M
