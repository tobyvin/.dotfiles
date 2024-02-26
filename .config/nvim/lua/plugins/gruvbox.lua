---@type LazyPluginSpec
local M = {
	-- "ellisonleao/gruvbox.nvim",
	-- TODO: revert once https://github.com/ellisonleao/gruvbox.nvim/pull/315 is merged
	"JulesNP/gruvbox.nvim",
	branch = "tsfix",
	priority = 1000,
	opts = {
		contrast = "hard",
		transparent_mode = true,
		overrides = {
			DiffDelete = { link = "GruvboxRed" },
			DiffAdd = { link = "GruvboxGreen" },
			DiffChange = { link = "GruvboxAqua" },
			DiffText = { link = "GruvboxYellow" },
			Delimiter = { link = "Special" },
			-- better typst highlighting
			["@lsp.type.string"] = { link = "@string" },
			["@lsp.type.keyword"] = { link = "@keyword" },
			["@lsp.type.operator"] = { link = "@operator" },
			["@lsp.type.number"] = { link = "@number" },
			["@lsp.type.bool"] = { link = "@boolean" },
			["@lsp.type.punct"] = { link = "@punctuation" },
			["@lsp.type.escape"] = { link = "@string.escape" },
			["@lsp.type.link"] = { link = "@text.uri" },
			["@lsp.type.raw"] = { link = "@text.literal" },
			["@lsp.type.label"] = { link = "@label" },
			["@lsp.type.ref"] = { link = "@text.reference" },
			["@lsp.type.heading"] = { link = "@string.special" },
			["@lsp.type.marker"] = { link = "@tag" },
			["@lsp.type.term"] = { link = "@symbol" },
			["@lsp.type.delim"] = { link = "@tag.delimiter" },
			["@lsp.type.pol"] = { link = "@property" },
			["@lsp.type.error"] = { link = "@error" },
			["@lsp.type.text"] = { link = "@text" },
			["@lsp.mod.strong"] = { link = "@text.strong" },
			["@lsp.mod.emph"] = { link = "@text.emphasis" },
			["@lsp.mod.math"] = { link = "@text.math" },
		},
	},
}

return M
