local M = {
	"sourcegraph/sg.nvim",
	cmd = {
		"CodyDo",
		"CodyAsk",
		"CodyChat",
		"CodyTask",
		"CodyToggle",
		"CodyRestart",
		"CodyTaskNext",
		"CodyTaskPrev",
		"CodyTaskView",
		"CodyTaskAccept",
		"SourcegraphInfo",
		"SourcegraphLink",
		"SourcegraphBuild",
		"SourcegraphLogin",
		"SourcegraphSearch",
		"SourcegraphDownloadBinaries",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		accept_tos = true,
		download_binaries = false,
		skip_node_check = true,
		on_attach = function() end,
	},
}

return M
