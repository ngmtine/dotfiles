-- minipc検証環境用 neovim 設定
-- 最小プラグイン構成: vim-tmux-navigator + iceberg + treesitter + bufferline

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core.options")
require("core.keymaps")
require("plugins")
