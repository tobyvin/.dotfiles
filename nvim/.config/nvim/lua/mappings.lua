local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local opts = {
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	-- Ctrl maps
	["<C-s>"] = { "<cmd>w!<CR>", "Save" },
	["<C-b>"] = { "<Cmd>Neotree focus toggle<CR>", "Explorer" },
}

local nopts = {
	mode = "n", -- NORMAL mode
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local nmappings = {
	-- Ctrl maps
	["<C-/>"] = { "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", "Comment" },

	-- Prefix "<leader>"
	["<leader>"] = {
		a = { "<cmd>Alpha<cr>", "Alpha" },
		f = { "<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown<cr>", "Buffers" },
		c = { "<cmd>Bdelete!<CR>", "Close Buffer" },
		q = { "<cmd>q!<CR>", "Quit" },
		R = { "<cmd>lua require('renamer').rename()<cr>", "Rename" },
		w = { "<cmd>w!<CR>", "Save" },
		W = { ":set wrap! linebreak!<CR>", "Toggle Line Wrap" },
		z = { "<cmd>ZenMode<cr>", "Zen" },
		["/"] = { "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", "Comment" },

		f = {
			name = "Find",
			b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
			c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
			C = { "<cmd>Telescope commands<cr>", "Commands" },
			e = { "<cmd>Telescope frecency theme=get_dropdown<cr>", "Frecency" },
			f = { "<cmd>Telescope find_files theme=get_dropdown<cr>", "Find files" },
			g = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
			h = { "<cmd>Telescope help_tags<cr>", "Help" },
			i = { "<cmd>lua require('telescope').extensions.media_files.media_files()<cr>", "Media" },
			k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
			l = { "<cmd>Telescope resume<cr>", "Last Search" },
			m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
			p = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
			r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
			R = { "<cmd>Telescope registers<cr>", "Registers" },
			s = { "<cmd>Telescope session-lens search_session<cr>", "Sessions" },
			t = { "<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown<cr>", "Buffers" },
		},

		g = {
			name = "Git",
			b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
			c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
			d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
			g = { "<cmd>LazyGit<CR>", "Lazygit" },
			j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
			k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
			l = { "<cmd>GitBlameToggle<cr>", "Blame" },
			o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
			p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
			r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
			R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
			s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
			u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
			w = {
				name = "Worktree",
				s = { [[<Cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>]], "Switch" },
				c = { [[<Cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>]], "Create" },
			},
		},

		l = {
			name = "LSP",
			a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
			d = { "<cmd>TroubleToggle<cr>", "Diagnostics" },
			f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
			-- F = { "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat" },
			g = {
				name = "Goto",
				d = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
				D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
				i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation" },
				r = { "<cmd>lua vim.lsp.buf.references()<CR>", "References" },
			},
			h = { "<Cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
			H = { "<Cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
			i = { "<cmd>LspInfo<cr>", "Info" },
			I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
			j = { "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", "Next Diagnostic" },
			k = { "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", "Prev Diagnostic" },
			l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
			o = { "<cmd>SymbolsOutline<cr>", "Outline" },
			q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
			r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
			R = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
			s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
			S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
			w = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
		},

		p = {
			name = "Packer",
			c = { "<cmd>PackerCompile<cr>", "Compile" },
			C = { "<cmd>PackerClean<cr>", "Clean" },
			i = { "<cmd>PackerInstall<cr>", "Install" },
			s = { "<cmd>PackerSync<cr>", "Sync" },
			S = { "<cmd>PackerStatus<cr>", "Status" },
			u = { "<cmd>PackerUpdate<cr>", "Update" },
		},

		r = {
			name = "Replace",
			f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
			r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
			w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
		},

		s = {
			name = "Surround",
			["."] = { "<cmd>lua require('surround').repeat_last()<cr>", "Repeat" },
			a = { "<cmd>lua require('surround').surround_add(true)<cr>", "Add" },
			b = { "<cmd>lua require('surround').toggle_brackets()<cr>", "Brackets" },
			d = { "<cmd>lua require('surround').surround_delete()<cr>", "Delete" },
			q = { "<cmd>lua require('surround').toggle_quotes()<cr>", "Quotes" },
			r = { "<cmd>lua require('surround').surround_replace()<cr>", "Replace" },
		},

		t = {
			name = "Terminal",
			["1"] = { ":1ToggleTerm<cr>", "1" },
			["2"] = { ":2ToggleTerm<cr>", "2" },
			["3"] = { ":3ToggleTerm<cr>", "3" },
			["4"] = { ":4ToggleTerm<cr>", "4" },
			f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
			h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
			v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
		},

		T = {
			name = "Treesitter",
			h = { "<cmd>TSHighlightCapturesUnderCursor<cr>", "Highlight" },
			p = { "<cmd>TSPlaygroundToggle<cr>", "Playground" },
		},
	},
	-- Prefix "m"
	m = {
		a = { "<cmd>BookmarkAnnotate<cr>", "Annotate" },
		c = { "<cmd>BookmarkClear<cr>", "Clear" },
		h = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "Harpoon" },
		j = { "<cmd>BookmarkNext<cr>", "Next" },
		k = { "<cmd>BookmarkPrev<cr>", "Prev" },
		m = { "<cmd>BookmarkToggle<cr>", "Toggle" },
		s = {
			"<cmd>lua require('telescope').extensions.vim_bookmarks.all({ hide_filename=false, prompt_title=\"bookmarks\", shorten_path=false })<cr>",
			"Show",
		},
		u = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "Harpoon UI" },
		x = { "<cmd>BookmarkClearAll<cr>", "Clear All" },
	},
}

local vopts = {
	mode = "v", -- VISUAL mode
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local vmappings = {
	-- Ctrl maps
	["<C-/>"] = { "<ESC><CMD>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>", "Comment" },

	-- Prefix "<leader>"
	["<leader>"] = {

		["/"] = { "<ESC><CMD>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>", "Comment" },
	},
}

local iopts = {
	mode = "i", -- INSERT mode
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local imappings = {
	-- Ctrl maps
	["<C-h>"] = { "<left>", "Left" },
	["<C-j>"] = { "<up>", "Up" },
	["<C-k>"] = { "<down>", "Down" },
	["<C-l>"] = { "<right>", "Right" },
}

which_key.register(mappings, opts)
which_key.register(nmappings, nopts)
which_key.register(vmappings, vopts)
which_key.register(imappings, iopts)

function WhichKeyNeoTree(bufNumber)
	local status_ok, which_key = pcall(require, "which-key")
	if not status_ok then
		return
	end

	vim.g.maplocalleader = " "
	vim.g.mapleader = ""

	local nopts = {
		mode = "n",
		buffer = vim.api.nvim_get_current_buf(),
		silent = true,
		noremap = true,
		nowait = true,
	}

	local nmappings = {
		["<2-LeftMouse>"] = { "<cmd> lua require('neo-tree').open()<cr>", "Open" },
		["<cr>"] = { "<cmd> lua require('neo-tree').open()<cr>", "Open" },
		["<localleader>"] = {
			S = { "<cmd> lua require('neo-tree').open_split()<cr>", "HSplit" },
			s = { "<cmd> lua require('neo-tree').open_vsplit()<cr>", "VSplit" },
			t = { "<cmd> lua require('neo-tree').open_tabnew()<cr>", "New Tab" },
			C = { "<cmd> lua require('neo-tree').close_node()<cr>", "Collapse" },
			z = { "<cmd> lua require('neo-tree').close_all_nodes()<cr>", "Collapse All" },
			R = { "<cmd> lua require('neo-tree').refresh()<cr>", "Refresh" },
			a = { "<cmd> lua require('neo-tree').add()<cr>", "Add" },
			A = { "<cmd> lua require('neo-tree').add_directory()<cr>", "Add Dir" },
			d = { "<cmd> lua require('neo-tree').delete()<cr>", "Delete" },
			r = { "<cmd> lua require('neo-tree').rename()<cr>", "Rename" },
			y = { "<cmd> lua require('neo-tree').copy_to_clipboard()<cr>", "Copy" },
			x = { "<cmd> lua require('neo-tree').cut_to_clipboard()<cr>", "Cut" },
			p = { "<cmd> lua require('neo-tree').paste_from_clipboard()<cr>", "Paste" },
			c = { "<cmd> lua require('neo-tree').copy()<cr>", "Copy To" },
			m = { "<cmd> lua require('neo-tree').move()<cr>", "Move To" },
			q = { "<cmd> lua require('neo-tree').close_window()<cr>", "Close" },
		},
	}
	which_key.register(nmappings, nopts)
end

local bufNo = vim.api.nvim_get_current_buf()

vim.cmd("autocmd FileType neo-tree lua WhichKeyNeoTree(" .. bufNo .. ")")
