-- Metadata
-- languages: python,go,php,html
-- url: https://djlint.com/

local fs = require("efmls-configs.fs")

local bin = fs.executable("djlint")
local args = "--reformat ${--indent:tabSize} --profile=django -"
local command = string.format("%s %s", bin, args)

return {
	formatCommand = command,
	formatStdin = true,
}
