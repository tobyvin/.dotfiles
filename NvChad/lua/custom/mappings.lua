local map = require("core.utils").map

map("n", "<leader>r", ":NvimTreeRefresh<CR>")
map("n", "<C-b>", ":NvimTreeToggle<CR>")
map("n", "<C-F>", ":!tmux-sessionizer<CR>")

