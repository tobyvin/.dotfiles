local M = {
	"akinsho/git-conflict.nvim",
}

function M.config()
	local git_conflict = require("git-conflict")

	git_conflict.setup({
		disable_diagnostics = true,
		highlights = {
			incoming = "diffText",
			current = "diffAdd",
		},
	})
end

return M
