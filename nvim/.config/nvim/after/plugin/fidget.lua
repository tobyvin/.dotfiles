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
