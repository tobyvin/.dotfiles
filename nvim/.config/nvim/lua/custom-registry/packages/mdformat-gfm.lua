local Pkg = require("mason-core.package")
local pip3 = require("mason-core.managers.pip3")

return Pkg.new({
	name = "mdformat-gfm",
	desc = "Mdformat plugin for GitHub Flavored Markdown compatibility.",
	homepage = "https://github.com/hukkin/mdformat-gfm/",
	licenses = { "MIT" },
	languages = { Pkg.Lang.Markdown },
	categories = { Pkg.Cat.Formatter },
	install = pip3.packages({ "mdformat-gfm", bin = { "mdformat" } }),
})
