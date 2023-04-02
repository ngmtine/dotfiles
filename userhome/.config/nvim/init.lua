---@diagnostic disable: undefined-global

require('packer').startup(function(use)
	-- packer
	use "wbthomason/packer.nvim"
	-- UI
	use "cocopon/iceberg.vim"
	use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
	use "edkolev/tmuxline.vim"
	use "norcalli/nvim-colorizer.lua"
	use "christoomey/vim-tmux-navigator"
	-- use "ryanoasis/vim-devicons"

	-- editor
	use "preservim/nerdcommenter"
	use "cohama/lexima.vim"
	use "machakann/vim-sandwich"
	use "lambdalisue/suda.vim"
	-- use { "ojroques/vim-oscyank", branch = "main" }
end)

-- map leader
vim.g.mapleader = " "

-- UI
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.showtabline = 2
vim.api.nvim_command([[set list listchars=tab:▸-,eol:↲,trail:_]])

-- file handling
vim.opt.fileencodings = { "utf-8", "cp932" }
vim.opt.autoread = true
vim.opt.swapfile = false

-- filetype
vim.cmd [[
	autocmd BufEnter *.fish set filetype=sh
]]

-- When a line break occurs on a comment line, the next line is not commented out either.
vim.api.nvim_create_autocmd({ "FileType" }, {
	callback = function()
		vim.opt.formatoptions = "jql"
	end,
})

-- mkdir before writing to a nonexistent dir
vim.cmd [[
	augroup vimrc-auto-mkdir
	autocmd!
	function! s:auto_mkdir(dir, force)
	if !isdirectory(a:dir) && (a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
	call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
	endif
	endfunction
	autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
	augroup END
]]

-- undo persistance
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo/")

-- indent
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0
vim.opt.smarttab = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- restore cursor location
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
		vim.cmd('silent! normal! g`"zv')
	end,
})

-- theme & airline
pcall(vim.api.nvim_command, "colorscheme iceberg")
require('lualine').setup()

-- clipboard
vim.cmd([[ set clipboard^=unnamedplus ]])
vim.keymap.set("n", "<leader>p", [[ o<esc>"+gp ]])
vim.keymap.set("n", "<leader>P", [[ <s-o><esc>"+gP ]])
-- vim.keymap.set("n", "p", [[ :let @"=@+ <cr> p ]])

vim.g.clipboard = {
	name = 'win32yank',
	copy = {
		['+'] = 'win32yank.exe -i',
		['*'] = 'win32yank.exe -i',
	},
	paste = {
		['+'] = 'win32yank.exe -o',
		['*'] = 'win32yank.exe -o',
	},
	cache_enabled = 1,
}

-- nerd commenter
vim.g.NERDCreateDefaultMappings = 0
vim.g.NERDSpaceDelims = 1

-- colorizer
require 'colorizer'.setup()

-- keymap
vim.keymap.set("n", "<tab>", "gt")
vim.keymap.set("n", "<s-tab>", "gT")
-- vim.keymap.set("n", "<s-h>", "^")
-- vim.keymap.set("v", "<s-h>", "^")
-- vim.keymap.set("n", "<s-l>", "$")
-- vim.keymap.set("v", "<s-l>", "$")
vim.keymap.set("n", "<s-y>", "y$")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("i", "<c-a>", "<c-o>^")
vim.keymap.set("i", "<c-e>", "<esc>$i<right>")
vim.keymap.set("i", "<c-k>", "<esc><right>d$i")
vim.keymap.set("n", "U", "<c-r>")
vim.keymap.set("n", "<", "<<")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("n", ">", ">>")
vim.keymap.set("v", ">", ">gv")
-- vim.keymap.set("n", "p", "p`]")
-- vim.keymap.set("v", "p", "p`]")
vim.keymap.set("n", "<c-l>", ":<c-u>nohlsearch<cr><c-l>")
vim.keymap.set("c", "<c-a>", "<home>")
vim.keymap.set("c", "<c-e>", "<end>")
vim.keymap.set("i", "<space>", "<space><c-g>u")
-- vim.keymap.set("n", "<c-r>", ":source $MYVIMRC<cr>:PackerSync<cr>")
vim.keymap.set("n", "*", "*N")
vim.keymap.set("n", "q:", ":echo '履歴は誤爆しがちなので潰す！'<cr>")
vim.keymap.set("v", "<s-i>", "^<s-i>")
vim.keymap.set("v", "<s-a>", "$<s-a>")

-- map leader
-- switch word with plus register
vim.keymap.set("n", "<Leader>rep", '"_dw"+P')
vim.keymap.set("v", "<Leader>rep", '"_d"+P')
vim.keymap.set("n", "<Leader>a", 'ggVG')
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap=true, silent=true})

-- nnoremap <c-/> "comment toggle"
-- in windows, underscore means slash
vim.keymap.set("n", "<c-_>", "<plug>NERDCommenterToggle")
vim.keymap.set("v", "<c-_>", "<plug>NERDCommenterToggle")

-- vim-tmux-navigator
vim.g.tmux_navigator_no_mappings = 1
vim.g.tmux_navigator_save_on_switch = 2

vim.keymap.set("n", "<A-h>", ":TmuxNavigateLeft<cr>", { silent = true })
vim.keymap.set("n", "<A-j>", ":TmuxNavigateDown<cr>", { silent = true })
vim.keymap.set("n", "<A-k>", ":TmuxNavigateUp<cr>", { silent = true })
vim.keymap.set("n", "<A-l>", ":TmuxNavigateRight<cr>", { silent = true })

-- quickfix
vim.cmd [[
	autocmd QuickFixCmdPost *grep* cwindow
]]

