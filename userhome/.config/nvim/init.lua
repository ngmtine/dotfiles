---@diagnostic disable: undefined-global

require('packer').startup(function(use)
	-- packer
	use "wbthomason/packer.nvim"
	-- UI
	use "cocopon/iceberg.vim"
	use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
	use "edkolev/tmuxline.vim"

	use "preservim/nerdcommenter"
	-- use { "ojroques/vim-oscyank", branch = "main" }
	use "norcalli/nvim-colorizer.lua"

	use "christoomey/vim-tmux-navigator"
	use "lambdalisue/suda.vim"

	-- editor
	use "cohama/lexima.vim"

	-- LSP
	use 'neovim/nvim-lspconfig'
	use 'williamboman/mason.nvim'
	use 'williamboman/mason-lspconfig.nvim'

	use "hrsh7th/nvim-cmp"
	use "hrsh7th/cmp-nvim-lsp"
	use "hrsh7th/vim-vsnip"
	use "hrsh7th/cmp-path"
	use "hrsh7th/cmp-buffer"
	use "hrsh7th/cmp-cmdline"

	-- DAP
	use 'mfussenegger/nvim-dap'
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

-- nerd commenter
vim.g.NERDCreateDefaultMappings = 0
vim.g.NERDSpaceDelims = 1

-- colorizer
require 'colorizer'.setup()

-- keymap
vim.keymap.set("n", "<tab>", "gt")
vim.keymap.set("n", "<s-tab>", "gT")
vim.keymap.set("n", "<s-h>", "^")
vim.keymap.set("v", "<s-h>", "^")
vim.keymap.set("n", "<s-l>", "$")
vim.keymap.set("v", "<s-l>", "$")
vim.keymap.set("n", "<s-y>", "y$")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("i", "<c-a>", "<esc>^i")
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
vim.keymap.set("n", "<c-r>", ":source $MYVIMRC<cr>")

-- map leader
-- switch word with plus register
vim.keymap.set("n", "<Leader>rep", '"_dw"+P')
vim.keymap.set("v", "<Leader>rep", '"_d"+P')
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

-- LSP Sever management
require('mason').setup()
require('mason-lspconfig').setup_handlers({ function(server)
	local opt = {
		-- Function executed when the LSP server startup
		on_attach = function(client, bufnr)
			local opts = { noremap = true, silent = true }
			vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
			vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
		end,
		capabilities = require('cmp_nvim_lsp').default_capabilities(
		vim.lsp.protocol.make_client_capabilities()
		)
	}
	require('lspconfig')[server].setup(opt)
end })

-- build-in LSP function
-- keyboard shortcut
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
-- LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)

-- completion (hrsh7th/nvim-cmp)
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<tab>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<S-tab>"] = cmp.mapping.select_prev_item(),
		['<C-l>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		-- ['<esc>'] = cmp.mapping.abort(), -- この設定を行うとescで抜けるときラグが発生する
		['<C-j>'] = cmp.mapping.abort(), -- そのため普段自分がahkでescに宛ててるキーを直接指定する
		['<CR>'] = cmp.mapping.confirm({ select = false }),
	}),
	experimental = {
		ghost_text = true,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})
cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "path" },
		{ name = "cmdline" },
	},
})

-- dap (mfussenegger/nvim-dap)
-- 動かし方わからん
local dap = require('dap')

dap.set_log_level("DEBUG")

vim.api.nvim_set_keymap("n", "<F9>", "<CMD>lua require('dap').toggle_breakpoint()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F5>", ":lua require('dap').continue()<CR>", { noremap = true, silent = false })

dap.adapters.chrome = {
	type = "executable",
	command = "node",
	args = {os.getenv("HOME") .. "/ghq/github.com/Microsoft/vscode-chrome-debug/out/src/chromeDebug.js"}
}

dap.adapters.firefox = {
	  type = 'executable',
	  command = 'node',
	args = {os.getenv("HOME") .. "/ghq/github.com/Microsoft/vscode-chrome-debug/out/src/chromeDebug.js"}
}

dap.configurations.javascript = {
	{
		type = "firefox",
		request = "attach",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		port = 9222,
		webRoot = "${workspaceFolder}"
	}
}
