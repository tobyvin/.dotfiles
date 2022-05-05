local g = vim.g -- global variables
local opt = vim.opt -- vim options
local exec = vim.api.nvim_exec -- execute Vimscript

g.mapleader = " "

vim.g.gruvbox_flat_style = "hard"
vim.g.gruvbox_theme = { TabLineSel = { bg = "orange" } }
vim.cmd([[colorscheme gruvbox-flat]])


g.tex_flavor = "latex"

-- global options
local options = {
	background = "dark",
	termguicolors = true, -- Enable GUI colors for the terminal to get truecolor
	list = false, -- show whitespace
	listchars = {
		nbsp = "⦸", -- CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
		extends = "»", -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
		precedes = "«", -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
		tab = "▷─", -- WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7) + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
		trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
		space = " ",
	},
	fillchars = {
		diff = "∙", -- BULLET OPERATOR (U+2219, UTF-8: E2 88 99)
		eob = " ", -- NO-BREAK SPACE (U+00A0, UTF-8: C2 A0) to suppress ~ at EndOfBuffer
		fold = "·", -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
		vert = " ", -- remove ugly vertical lines on window division
	},
	undofile = true,
	undodir = vim.fn.stdpath("config") .. "/undo",
	clipboard = opt.clipboard + "unnamedplus", -- copy & paste
	shortmess = opt.shortmess + "c",
	wrap = false, -- don't automatically wrap on load
	showmatch = true, -- show the matching part of the pair for [] {} and ()
	cursorline = true, -- highlight current line
	number = true, -- show line numbers
	relativenumber = true, -- show relative line number
	incsearch = true, -- incremental search
	hlsearch = true, -- highlighted search results
	ignorecase = true, -- ignore case sensetive while searching
	smartcase = true,
	scrolloff = 1, -- when scrolling, keep cursor 1 lines away from screen border
	sidescrolloff = 2, -- keep 30 columns visible left and right of the cursor at all times
	backspace = "indent,start,eol", -- make backspace behave like normal again
	mouse = "a", -- turn on mouse interaction
	updatetime = 500, -- CursorHold interval
	expandtab = true,
	softtabstop = 4,
	textwidth = 100,
	shiftwidth = 4, -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
	tabstop = 4, -- spaces per tab
	smarttab = true, -- <tab>/<BS> indent/dedent in leading whitespace
	autoindent = true, -- maintain indent of current line
	shiftround = true,
	splitbelow = true, -- open horizontal splits below current window
	splitright = true, -- open vertical splits to the right of the current window
	laststatus = 2, -- always show status line
	colorcolumn = "100", -- vertical word limit line
	hidden = true, -- allows you to hide buffers with unsaved changes without being prompted
	inccommand = "split", -- live preview of :s results
	shell = "zsh", -- shell to use for `!`, `:!`, `system()` etc.
	wildignore = opt.wildignore + "*.o,*.rej,*.so",
	lazyredraw = true,
	completeopt = "menuone,noselect,noinsert",
	sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
