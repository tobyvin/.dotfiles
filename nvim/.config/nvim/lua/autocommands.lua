-- to Show whitespace, MUST be inserted BEFORE the colorscheme command
vim.cmd([[
	augroup general_settings
		autocmd!
		autocmd FileType qf,help,man,lspinfo,spectre_panel nnoremap <silent> <buffer> q :close<CR>
		autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
		autocmd BufWritePre * :%s/\s\+$//e
		autocmd BufWinEnter * :set formatoptions-=cro
		autocmd BufEnter * set fo-=c fo-=r fo-=o
		autocmd FileType qf set nobuflisted
		autocmd CmdWinEnter * quit
		autocmd FileType xml,html,xhtml,css,scss,javascript,lua,dart setlocal shiftwidth=2 tabstop=2
		autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
	augroup end

	augroup format_on_save
		autocmd!
		autocmd BufWritePre * lua vim.lsp.buf.formatting()
	augroup end

	augroup auto_search_highlighting
		autocmd!
		autocmd CmdlineEnter /,\? set hlsearch
		autocmd CmdlineLeave /,\? set nohlsearch
	augroup END

	augroup _git
		autocmd!
		autocmd FileType gitcommit setlocal wrap
		autocmd FileType gitcommit setlocal spell
	augroup end

	augroup _markdown
		autocmd!
		autocmd FileType markdown setlocal wrap
		autocmd FileType markdown setlocal spell
		autocmd BufNewFile,BufRead *.mdx set filetype=markdown
	augroup end

	augroup _latex
		autocmd!
		autocmd FileType latex,tex,plaintex setlocal wrap
		autocmd FileType latex,tex,plaintex setlocal spell
		autocmd FileType latex,tex,plaintex setlocal linebreak
	augroup end

	augroup _json
		autocmd!
		autocmd BufEnter *.json set ai expandtab shiftwidth=2 tabstop=2 sta fo=croql
	augroup end

	augroup _auto_resize
		autocmd!
		autocmd VimResized * tabdo wincmd =
	augroup end

	augroup _alpha
		autocmd!
		autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
	augroup end
]])
