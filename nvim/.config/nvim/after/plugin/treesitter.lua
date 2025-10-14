local success, nvim_treesitter = pcall(require, "nvim-treesitter")
if not success then
	return
end

local install = nvim_treesitter.install({
	"cmake",
	"cpp",
	"c_sharp",
	"css",
	"comment",
	"diff",
	"gitignore",
	"go",
	"graphql",
	"html",
	"java",
	"javascript",
	"jsdoc",
	"jsonc",
	"json",
	"latex",
	"make",
	"python",
	"regex",
	"ron",
	"rust",
	"scss",
	"sql",
	"svelte",
	"toml",
	"tsx",
	"typescript",
	"typst",
	"vue",
	"yaml",
	"zig",
})

if #vim.api.nvim_list_uis() == 0 then
	install:wait(300000)
end
