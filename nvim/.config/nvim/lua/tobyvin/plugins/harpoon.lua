local M = {
	"ThePrimeagen/harpoon",
	config = true,
}

function M.init()
	vim.keymap.set("n", "gm", function()
		require("harpoon.mark").add_file()
	end, { desc = "add mark" })

	vim.keymap.set("n", "gM", function()
		require("harpoon.ui").toggle_quick_menu()
	end, { desc = "marks" })

	vim.keymap.set("n", "gn", function()
		require("harpoon.ui").nav_next()
	end, { desc = "next mark" })

	vim.keymap.set("n", "gp", function()
		require("harpoon.ui").nav_prev()
	end, { desc = "prev mark" })

	for i = 1, 10, 1 do
		vim.keymap.set("n", string.format("g%s", i), function()
			require("harpoon.ui").nav_file(i)
		end, { desc = string.format("mark %s", i) })
	end
end

return M
