local status_ok, packer = pcall(require, "packer")
if not status_ok then
	vim.notify("Failed to load module 'packer'", vim.log.levels.ERROR)
	return
end

vim.keymap.set("n", "<leader>pc", packer.compile, { desc = "compile" })
vim.keymap.set("n", "<leader>pC", packer.clean, { desc = "clean" })
vim.keymap.set("n", "<leader>pi", packer.install, { desc = "install" })
vim.keymap.set("n", "<leader>pp", packer.profile_output, { desc = "profile" })
vim.keymap.set("n", "<leader>ps", packer.sync, { desc = "sync" })
vim.keymap.set("n", "<leader>pu", packer.update, { desc = "update" })

vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("tobyvin_packer_complete", { clear = true }),
	pattern = "PackerComplete",
	callback = function()
		packer.snapshot(os.date("%Y-%m-%d_%H-%M-%S"))
	end,
	desc = "create snapshot on PackerComplete",
})

packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "single" })
		end,
	},
	autoremove = true,
})

return packer
