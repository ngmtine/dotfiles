-- style --------------------------------------------------
vim.opt.termguicolors = true -- truecolor有効化
vim.opt.number = true
vim.opt.showtabline = 2      -- タブ常に表示
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- 特殊文字
vim.opt.list = true
vim.opt.listchars = { tab = "▸-", trail = "_", eol = "↲" }

-- edit --------------------------------------------------
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus" -- クリップボード共有 .bashrcとかでwin32yank.exeへのパス通しておく必要あり
vim.opt.encoding = 'utf-8'
vim.scriptencoding = 'utf-8'
vim.opt.swapfile = false

-- インデント
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0
vim.opt.smarttab = true

-- 検索
vim.opt.smartcase = true

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

-- exコマンドの実行結果をバッファに表示
-- 例: :PipeBuffer :map
local function PipeBuffer(cmd)
    local result = vim.api.nvim_command_output(cmd)
    vim.cmd('tabe')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result, "\n"))
    vim.bo.modifiable = true
    vim.bo.modified = true
end

-- ユーザーコマンドの作成
vim.api.nvim_create_user_command('PipeBuffer', function(opts)
    PipeBuffer(opts.args)
end, { nargs = 1, complete = 'command' })

-- htmlの任意の属性を削除する関数
-- TODO: 範囲選択に対応する
local function RemoveHtmlAttributes(args)
    local patterns = {}

    if args.args == "" then
        -- 引数がない場合はすべての属性を削除
        table.insert(patterns, '\\s\\+[a-zA-Z0-9_-]\\+\\s*=\\s*"[^"]*"')
    else
        -- 引数がある場合、複数の属性名を処理
        for attribute in string.gmatch(args.args, "%S+") do
            table.insert(patterns, '\\s\\+' .. attribute .. '\\s*=\\s*"[^"]*"')
        end
    end

    -- 各パターンで置換を実行
    for _, pattern in ipairs(patterns) do
        vim.cmd('%s/' .. pattern .. '//g')
    end
end

-- ユーザーコマンドの作成
vim.api.nvim_create_user_command('RmAttr', RemoveHtmlAttributes, { nargs = '*' })
