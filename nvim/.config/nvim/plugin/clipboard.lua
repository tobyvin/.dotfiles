-- workaround for alacritty not supporting XTGETTCAP
-- Ref: https://github.com/alacritty/vte/issues/98

local terms = {
	"alacritty",
}

local tty = false
for _, ui in ipairs(vim.api.nvim_list_uis()) do
	if ui.chan == 1 and ui.stdout_tty then
		tty = true
		break
	end
end

if
	tty
	and (vim.g.clipboard == nil or vim.o.clipboard == "")
	and os.getenv("SSH_TTY")
	and vim.list_contains(terms, vim.env.TERM)
then
	local osc52 = require("vim.ui.clipboard.osc52")

	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = osc52.copy("+"),
			["*"] = osc52.copy("*"),
		},
		paste = {
			["+"] = osc52.paste("+"),
			["*"] = osc52.paste("*"),
		},
	}
end
