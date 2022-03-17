local map = require('cartographer')

vim.g.mapleader = ' '

-- wrap
map.n.nore['<Leader>w'] = ':set wrap! linebreak!<CR>'
map.n.nore['j'] = 'gj'
map.n.nore['k'] = 'gk'

-- navigation
--- behave like other capitals
map.n.nore['Y'] = 'y$'

--- keeping it centered
map.n.nore['n'] = 'nzzzv'
map.n.nore['N'] = 'Nzzzv'
map.n.nore['J'] = 'mzJ`z'

--- moving text
map.v.nore['J'] = [[:m '>+1<CR>gv=gv]]
map.v.nore['K'] = [[:m '<-2<CR>gv=gv]]
map.n.nore['<leader>k'] = ':m .-2<CR>=='
map.n.nore['<leader>j'] = ':m .+1<CR>=='

-- telescope
map.n.nore.silent['<C-a>'] = [[<Cmd>Telescope buffers show_all_buffers=true theme=get_dropdown<CR>]]
map.n.nore.silent['<C-e>'] = [[<Cmd>Telescope frecency theme=get_dropdown<CR>]]
map.n.nore.silent['<C-h>'] = [[<Cmd>Telescope git_files theme=get_dropdown<CR>]]
map.n.nore.silent['<C-d>'] = [[<Cmd>Telescope find_files theme=get_dropdown<CR>]]
map.n.nore.silent['<C-g>'] = [[<Cmd>Telescope live_grep theme=get_dropdown<CR>]]
-- map.v.nore.silent["<leader>rr"] = [[:lua require('telescope').extensions.refactoring.refactors()<CR>]]

-- refactoring
map.v.nore.silent['<leader>re'] = [[:lua require("refactoring").refactor(106)<CR>]]
map.n.nore.silent['<leader>ri'] = [[:lua require("refactoring").refactor(123)<CR>]]
map.n.nore.silent['<leader>dh'] = [[:lua print(vim.inspect(require("refactoring").debug.get_path()))<CR>]]
map.n.nore.silent['<leader>dg'] = [[:lua require("refactoring").debug.printf({below = false})<CR>]]
map.n.nore.silent['<leader>dm'] = [[:lua require("refactoring").debug.printf({below = true})<CR>]]
map.n.nore.silent['<leader>df'] = [[:lua require("refactoring").debug.print_var({below = false})<CR>]]
map.n.nore.silent['<leader>db'] = [[:lua require("refactoring").debug.print_var({below = true})<CR>]]

--- quicklist
map.n.nore['<leader>qn'] = '<Cmd>:cnext<CR>'
map.n.nore['<leader>qp'] = '<Cmd>:cprev<CR>'
map.n.nore['<leader>qo'] = '<Cmd>:copen<CR>'

-- lua tree
require'nvim-tree'.setup {}
map.nore['<C-b>'] = '<Cmd>NvimTreeToggle<CR>'
map.n.nore['<Leader>tf'] = '<Cmd>NvimTreeFindFileToggle<CR>'
map.n.nore['<Leader>tr'] = '<Cmd>NvimTreeRefresh<CR>'

-- language server
map.n.nore['<Leader>vd'] = '<Cmd>lua vim.lsp.buf.definition()<CR>'
map.n.nore['<Leader>vi'] = '<Cmd>lua vim.lsp.buf.implementation()<CR>'
map.n.nore['<Leader>vsh'] = '<Cmd>lua vim.lsp.buf.signature_help()<CR>'
map.n.nore['<Leader>vrr'] = '<Cmd>lua vim.lsp.buf.references()<CR>'
map.n.nore['<Leader>vrn'] = '<Cmd>lua vim.lsp.buf.rename()<CR>'
map.n.nore['<Leader>vh'] = '<Cmd>lua vim.lsp.buf.hover()<CR>'
map.n.nore['<Leader>vca'] = '<Cmd>lua vim.lsp.buf.code_action()<CR>'
map.n.nore['<Leader>vsd'] = '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'
map.n.nore['<Leader>vn'] = '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>'
map.n.nore['<Leader>vp'] = '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>'
map.n.nore['<Leader>vf'] = '<Cmd>Format<CR>'

-- debug
map.n.nore['<F5>'] = [[<Cmd>lua require('dap').continue()<CR>]]
map.n.nore['<F10>'] = [[<Cmd>lua require('dap').step_over()<CR>]]
map.n.nore['<F11>'] = [[<Cmd>lua require('dap').step_into()<CR>]]
map.n.nore['<F12>'] = [[<Cmd>lua require('dap').step_out()<CR>]]

-- git
local function git_branches()
	require("telescope.builtin").git_branches({
        attach_mappings = function(_, map)
			map("i", "<C-d>", actions.git_delete_branch)
			map("n", "<C-d>", actions.git_delete_branch)
			return true
		end,
	})
end

map.n.nore['<leader>gb'] = git_branches
map.n.nore['<Leader>go'] = '<Cmd>Neogit<CR>'
map.n.nore['<Leader>gc'] = '<Cmd>Neogit commit<CR>'
map.n.nore['<Leader>gws'] = [[<Cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>]]
map.n.nore['<Leader>gwc'] = [[<Cmd>:lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>]]
