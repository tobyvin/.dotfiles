local language_id_of = {
	menhir = "ocaml.menhir",
	ocaml = "ocaml",
	ocamlinterface = "ocaml.interface",
	ocamllex = "ocaml.ocamllex",
	reason = "reason",
	dune = "dune",
}

local get_language_id = function(_, ftype)
	return language_id_of[ftype]
end

---@type vim.lsp.Config
return {
	cmd = { "ocamllsp" },
	filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamllex", "reason", "dune" },
	root_markers = {
		"*.opam",
		"esy.json",
		"package.json",
		".git",
		"dune-project",
		"dune-workspace",
	},
	get_language_id = get_language_id,
}
