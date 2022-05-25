local mappings = {
	{
		-- NORMAL mode
		opts = {},
		mappings = {
			["<C-s>"] = { "<cmd>w!<CR>", "Save" },
			["<C-/>"] = { "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", "Comment" },
			["<leader>"] = {
				c = { "<cmd>Bdelete!<CR>", "Close Buffer" },
				q = { "<cmd>q!<CR>", "Quit" },
				R = { "<cmd>lua require('renamer').rename()<cr>", "Rename" },
				w = { "<cmd>w!<CR>", "Save" },
				W = { ":set wrap! linebreak!<CR>", "Toggle Line Wrap" },
				z = { "<cmd>ZenMode<cr>", "Zen" },
				["/"] = { "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", "Comment" },

				f = {
					name = "Find",
					b = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Buffers" },
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
					r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
					R = { "<cmd>Telescope registers<cr>", "Registers" },
					s = { "<cmd>Telescope session-lens search_session<cr>", "Sessions" },
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
						s = {
							[[<Cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>]],
							"Switch",
						},
						c = {
							[[<Cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>]],
							"Create",
						},
					},
				},

				l = {
					name = "LSP",
					a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
					d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
					D = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
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
				m = {
					name = "Markers",
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
			},
		},
	},
	{
		-- VISUAL mode
		opts = {
			mode = "v",
		},
		mappings = {
			-- Ctrl maps
			["<C-/>"] = {
				"<ESC><CMD>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>",
				"Comment",
			},

			-- Prefix "<leader>"
			["<leader>"] = {
				["/"] = {
					"<ESC><CMD>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>",
					"Comment",
				},
			},
		},
	},
	{
		-- INSERT mode
		opts = {
			mode = "i",
		},
		mappings = {
			["<C-h>"] = { "<left>", "Left" },
			["<C-j>"] = { "<up>", "Up" },
			["<C-k>"] = { "<down>", "Down" },
			["<C-l>"] = { "<right>", "Right" },
		},
	},
}

local ok, legendary = pcall(require, "legendary")
if ok then
	legendary.setup()
end

local ok, which_key = pcall(require, "which-key")
if ok then
	for i, m in ipairs(mappings) do
		which_key.register(m.mappings, m.opts)
	end
end
