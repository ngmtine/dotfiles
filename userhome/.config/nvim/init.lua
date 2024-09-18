local is_vscode = vim.g.vscode == 1
vim.lsp.set_log_level("warn")

require("common")
require("keymap")
require("plugins/lazy")
require("plugins/theme")
require("plugins/treesitter")
require("plugins.nerdcommenter")
require("plugins.dial")
require("plugins.colorizer")

if not is_vscode then
    require("plugins/mason")
    require("plugins/lspconfig")
    require("plugins/lspconfig-lua")
    require("plugins/lspconfig-jsts")
    require("plugins/lspsaga")
    require("plugins/dapconfig")
    require("plugins/dapconfig-jsts")
    require("plugins/copilot")
    require("plugins/hlchunk")
    require("plugins.vim-tmux-navigator")
    require("plugins.lualine")
    require("plugins/suda")
    require("plugins/fzf")
else
end

-- edkolev/tmuxlineについて
-- tmuxlineはvim/vim-airline/lightline.vimのカラースキームを流用する（？）
-- ところで現在のdotfiles以下の.tmuxline.confは、vim-airlineから生成（:TmuxlineSnapshot）したもの
-- その後vim-airlineは重くてlualineに変更したが、これはtmuxlineが対応していない
-- 過去に生成した.tmuxline.confを引き続き使用するとして、プラグインとしてのtmuxlineは一旦削除の方向で
