local is_vscode = vim.g.vscode == 1

require("common")
require("keymap")
require("plugins.lazy")

-- 共通
require("plugins.nerdcommenter")
require("plugins.dial")
require("plugins.colorizer")

-- vscode
if is_vscode then

-- cui
else
    require("plugins.iceberg")
    require("plugins.vim-tmux-navigator")
    require("plugins.lualine")
    require("plugins.mason")
    require("plugins.lspconfig")
end

-- edkolev/tmuxlineについて
-- tmuxlineはvim/vim-airline/lightline.vimのカラースキームを流用する（？）
-- ところで現在のdotfiles以下の.tmuxline.confは、vim-airlineから生成（:TmuxlineSnapshot）したもの
-- その後vim-airlineは重くてlualineに変更したが、これはtmuxlineが対応していない
-- 過去に生成した.tmuxline.confを引き続き使用するとして、プラグインとしてのtmuxlineは一旦削除の方向で

