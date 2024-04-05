local M = {
	"nvimdev/epo.nvim",
	event = { "InsertEnter", "CmdlineEnter" },
	opts = {
		signature = true,
		signature_border = "single",
		kind_format = function(k)
			return k
		end,
	},
}

function M:config(opts)
	local completeopt = vim.opt.completeopt:get()
	require("epo").setup(opts)
	vim.opt.completeopt = completeopt
end

return M
