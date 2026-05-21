-- 表示
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.showtabline = 2
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 100
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", lead = "·", trail = "·", eol = "↲" }

-- 操作
vim.opt.mouse = "a"

-- エンコーディング
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "utf-8,sjis"
vim.scriptencoding = "utf-8"

-- ファイル
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- インデント
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ホスト側(Windows Terminal)のクリップボードへ送る
-- minipcは常にtmux内でnvimを使う前提。tmux popup内では nvim→OSC52 の経路が
-- 不安定だったため、tmux自身に load-buffer -w させる方式を採用
-- (tmux load-buffer -w が outer terminal へ OSC52 を emit する)
vim.opt.clipboard = "unnamedplus"
if vim.env.TMUX then
    vim.g.clipboard = {
        name = "tmux",
        copy = {
            ["+"] = { "tmux", "load-buffer", "-w", "-" },
            ["*"] = { "tmux", "load-buffer", "-w", "-" },
        },
        paste = {
            ["+"] = { "tmux", "save-buffer", "-" },
            ["*"] = { "tmux", "save-buffer", "-" },
        },
        cache_enabled = true,
    }
else
    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
            ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        paste = {
            ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
            ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
        },
    }
end
