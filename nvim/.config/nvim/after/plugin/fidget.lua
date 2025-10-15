-- TODO: eventually replace with native nvim_echo progress messages
-- Ref: https://github.com/neovim/neovim/issues/32537
local success, fidget = pcall(require, "fidget")
if not success then
	return
end

fidget.setup({
	notification = {
		window = {
			winblend = 0,
		},
	},
})
