-- style --------------------------------------------------
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.showtabline = 2 -- タブ常に表示

-- 特殊文字
vim.opt.list = true
vim.opt.listchars = { tab = "▸-", trail = "_", eol = "↲" }

-- editor --------------------------------------------------
vim.o.clipboard = "unnamedplus"
vim.o.encoding = 'utf-8'
vim.scriptencoding = 'utf-8'
vim.opt.mouse = "a"
vim.opt.autoread = true
vim.opt.swapfile = false
vim.api.nvim_set_option("ignorecase", true)
vim.api.nvim_set_option("smartcase", true)
vim.opt.incsearch = true
vim.api.nvim_set_option("scrolloff", 20) -- n行手前でスクロール開始する

-- インデント
vim.opt.expandtab = true 
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0
vim.opt.smarttab = true

-- コメント行で行追加した場合、新規行はコメントアウト状態にしない
vim.api.nvim_create_autocmd({ "FileType" }, {
    callback = function()
        vim.opt.formatoptions = "jql"
    end,
})

-- 存在しないディレクトリで保存しようとしたときにmkdir
vim.cmd([[
	augroup vimrc-auto-mkdir
	autocmd!
	function! s:auto_mkdir(dir, force)
	if !isdirectory(a:dir) && (a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
	call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
	endif
	endfunction
	autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
	augroup END
]])

-- undo 永続化
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo/")

-- カーソル位置永続化
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
        vim.cmd('silent! normal! g`"zv')
    end,
})


-- .fishを.shとして扱う
vim.cmd [[
    autocmd BufEnter *.fish set filetype=sh
]]


