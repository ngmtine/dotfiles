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
end
