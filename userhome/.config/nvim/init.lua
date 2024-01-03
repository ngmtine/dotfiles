-- 別ファイル読み込み
-- 場所は ~/.config/nvim/lua
-- ファイル名の指定に拡張子は書かない事
-- https://github.com/willelz/nvim-lua-guide-ja/blob/master/README.ja.md
local ok, _ = pcall(require, 'init_local')
if not ok then
    -- not loaded
end

-- vscode-neovimとして起動されているかの真偽値
local is_vscode = vim.g.vscode == 1

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- cuiとvscode-neovimの両方で使うプラグイン
local common_plugins = {
    { "norcalli/nvim-colorizer.lua" }, -- カラーコードに背景色つける
    { "preservim/nerdcommenter" },     -- コメントアウト
    { "machakann/vim-sandwich" },      -- vim-surrond的なやつ
    { "monaqa/dial.nvim" },            -- c-a, c-x の強化
    { "cohama/lexima.vim" },           -- 括弧補完
}

-- vscode-neovimでのみ使うプラグイン
local vscode_plugins = {
}

-- cuiでのみ使うプラグイン
local neovim_plugins = {
    { "cocopon/iceberg.vim" },                                                              -- カラースキーム
    { "nvim-lualine/lualine.nvim",     dependencies = { "kyazdani42/nvim-web-devicons" } }, -- ステータスライン
    { "edkolev/tmuxline.vim" },                                                             -- ステータスライン(tmux)
    { 'neoclide/coc.nvim',             branch = 'release' },                                -- LSP
    { "lambdalisue/suda.vim" },                                                             -- sudo保存
    { "christoomey/vim-tmux-navigator" },                                                   -- nvimとtmuxのペイン移動
}

function merge_tables(t1, t2)
    local merged = {}
    for _, v in ipairs(t1) do
        table.insert(merged, v)
    end
    for _, v in ipairs(t2) do
        table.insert(merged, v)
    end
    return merged
end

-- プラグイン読み込み
require("lazy").setup(
    merge_tables(common_plugins, is_vscode and vscode_plugins or neovim_plugins)
)

-- true color
vim.opt.termguicolors = true

-- colorizer
require("colorizer").setup()

-- マウス有効化
vim.opt.mouse = "a"

-- 行数表示
vim.opt.number = true

-- タブ常に表示
vim.opt.showtabline = 2

-- 特殊文字
vim.opt.list = true
vim.opt.listchars = { tab = "▸-", trail = "_", eol = "↲" }

-- インデント
vim.opt.expandtab = true -- tab押下をスペースに変換
vim.opt.tabstop = 4      -- tab押下時のスペース挿入数
vim.opt.shiftwidth = 4   -- インデント発生時のスペース挿入数
vim.opt.softtabstop = 0
vim.opt.smarttab = true

-- vim外で更新された場合自動リロード
vim.opt.autoread = true

-- swapfile作成しない
vim.opt.swapfile = false

-- コメント行で行追加した場合、新規行はコメントアウト状態にしない
vim.api.nvim_create_autocmd({ "FileType" }, {
    callback = function()
        vim.opt.formatoptions = "jql"
    end,
})

-- クリップボード連携
vim.o.clipboard = "unnamedplus"
-- vim.keymap.set("n", "<leader>p", [[ o<esc>"+gp ]])
-- vim.keymap.set("n", "<leader>P", [[ <s-o><esc>"+gP ]])
-- vim.keymap.set("n", "p", [[ :let @"=@+ <cr> p ]])

-- n行手前でスクロール開始する
vim.api.nvim_set_option("scrolloff", 20)

-- theme & airline
pcall(vim.api.nvim_command, "colorscheme iceberg")
require("lualine").setup()

-- 小文字で検索したときは大小区別せず、大文字を含む場合は区別する
vim.api.nvim_set_option("ignorecase", true)
vim.api.nvim_set_option("smartcase", true)

-- インクリメンタルサーチ
vim.opt.incsearch = true

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

-- map leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- keymap
vim.keymap.set("n", "<tab>", "gt")
vim.keymap.set("n", "<s-tab>", "gT")
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
vim.keymap.set("n", "*", "*N")
-- vim.keymap.set("n", "q:", ":echo '履歴は誤爆しがちなので潰す！'<cr>")

-- map leader keymap
-- なんでこれ設定してたのか思い出せん
-- vim.api.nvim_set_keymap('', '<Space>', '<Nop>', {
-- noremap = true,
-- silent = true
-- })
vim.keymap.set("n", "<Leader>rep", '"_dw"+P')
vim.keymap.set("v", "<Leader>rep", '"_d"+P')
vim.keymap.set("n", "<Leader>a", "ggVG")

-- Paste from * register with removing ^M^J
vim.api.nvim_set_keymap("n", "p", ":lua CleanPasteStar()<CR>", { noremap = true })
function _G.CleanPasteStar()
    local reg_type = vim.fn.getregtype("*")
    local raw_content = vim.fn.getreg("*")
    raw_content = raw_content:gsub("\r\n", "\n")
    if reg_type:sub(1, 1) == "V" or reg_type:sub(1, 1) == "\n" then
        raw_content = raw_content:gsub("\n$", "")
    end
    local lines = vim.split(raw_content, "\n", true)
    vim.api.nvim_put(lines, reg_type, true, true)
end

-- Paste from * register with removing ^M^J before the cursor
vim.api.nvim_set_keymap("n", "P", ":lua CleanPasteStarAbove()<CR>", { noremap = true })
function _G.CleanPasteStarAbove()
    local reg_type = vim.fn.getregtype("*")
    local raw_content = vim.fn.getreg("*")
    raw_content = raw_content:gsub("\r\n", "\n")
    if reg_type:sub(1, 1) == "V" or reg_type:sub(1, 1) == "\n" then
        raw_content = raw_content:gsub("\n$", "")
    end
    local lines = vim.split(raw_content, "\n", true)
    vim.api.nvim_put(lines, reg_type, false, true)
end

-- nerdcommenter
vim.g.NERDCreateDefaultMappings = 0
vim.g.NERDSpaceDelims = 1
-- in windows, underscore means slash
vim.keymap.set("n", "<c-_>", "<plug>NERDCommenterToggle")
vim.keymap.set("v", "<c-_>", "<plug>NERDCommenterToggle")

-- dial.nvim
vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
local augend = require("dial.augend")
require("dial.config").augends:register_group({
    default = {
        augend.integer.alias.decimal,
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,
        augend.integer.alias.octal,
        augend.integer.alias.binary,
        augend.date.alias["%Y/%m/%d"],
        augend.date.alias["%m/%d"],
        augend.date.alias["%-m/%-d"],
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%Y年%-m月%-d日"],
        augend.date.alias["%Y年%-m月%-d日(%ja)"],
        augend.date.alias["%H:%M:%S"],
        augend.date.alias["%H:%M"],
        augend.constant.alias.ja_weekday,
        augend.constant.alias.ja_weekday_full,
        augend.constant.alias.bool,
    },
})

-- .fishを.shとして扱う
-- vim.cmd [[
-- autocmd BufEnter *.fish set filetype=sh
-- ]]

-- cuiでのみ適用する設定
if not is_vscode then
    -- vim-tmux-navigator
    vim.g.tmux_navigator_no_mappings = 1
    vim.g.tmux_navigator_save_on_switch = 2

    vim.keymap.set("n", "<A-h>", ":TmuxNavigateLeft<cr>", {
        silent = true
    })
    vim.keymap.set("n", "<A-j>", ":TmuxNavigateDown<cr>", {
        silent = true
    })
    vim.keymap.set("n", "<A-k>", ":TmuxNavigateUp<cr>", {
        silent = true
    })
    vim.keymap.set("n", "<A-l>", ":TmuxNavigateRight<cr>", {
        silent = true
    })

    -- coc-nvim ----------------------------------------------------------
    -- 下の候補に移動 (Down または Tab)
    vim.keymap.set('i', '<Down>', "coc#pum#visible() ? coc#pum#next(1) : '<Down>'", { expr = true, silent = true })
    vim.keymap.set('i', '<Tab>', "coc#pum#visible() ? coc#pum#next(1) : '<Tab>'", { expr = true, silent = true })

    -- 上の候補に移動 (Up または Shift-Tab)
    vim.keymap.set('i', '<Up>', "coc#pum#visible() ? coc#pum#prev(1) : '<Up>'", { expr = true, silent = true })
    vim.keymap.set('i', '<S-Tab>', "coc#pum#visible() ? coc#pum#prev(1) : '<S-Tab>'", { expr = true, silent = true })

    -- Enterで確定
    vim.keymap.set('i', '<CR>', "coc#pum#visible() ? coc#pum#confirm() : '<CR>'", { expr = true, silent = true })

    -- Escでキャンセル
    vim.keymap.set('i', '<Esc>', "coc#pum#visible() ? coc#pum#cancel() : '<Esc>'", { expr = true, silent = true })
end
