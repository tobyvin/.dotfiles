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
	opts = {},
}

return M
