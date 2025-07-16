vim.lsp.config["*"] = {
	root_markers = { ".git" },
}

vim.lsp.enable({
	"basedpyright",
	"bashls",
	"clangd",
	"cssls",
	"dockerls",
	"gopls",
	"html",
	"lemminx",
	"lua_ls",
	"mesonlsp",
	"ocamllsp",
	"omnisharp",
	"perlnavigator",
	"ruff",
	"rust_analyzer",
	"taplo",
	"texlab",
	"tinymist",
	"ts_ls",
	"typos_lsp",
	"yamlls",
	"zls",
})
