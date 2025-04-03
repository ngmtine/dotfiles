local is_vscode = vim.g.vscode == 1
vim.lsp.set_log_level("warn")

require("common")
require("keymap")
require("plugins/lazy")
require("plugins/nerdcommenter")
require("plugins/dial")
require("plugins/colorizer")

if not is_vscode then
    require("plugins/theme")
    require("plugins/treesitter")
    require("plugins/mason")
    require("plugins/lspconfig")
    require("plugins/lspconfig-lua")
    require("plugins/lspconfig-jsts")
    require("plugins/lspconfig-sql")
    require("plugins/lspsaga")
    require("plugins/fidget")
    require("plugins/dapconfig")
    require("plugins/dapconfig-jsts")
    require("plugins/hlchunk")
    require("plugins/vim-tmux-navigator")
    require("plugins/lualine")
    require("plugins/suda")
    require("plugins/fzf")
end

-- ディレクトリ以下のluaを自動でrequireする
local function require_all(dir)
    local command_dir = vim.fn.stdpath('config') .. '/lua/' .. dir
    for _, file in ipairs(vim.fn.readdir(command_dir)) do
        if file:match("%.lua$") then
            local module_name = dir:gsub("/", ".") .. "." .. file:gsub("%.lua$", "")
            require(module_name)
        end
    end
end

-- commandsディレクトリ以下全てrequire
require_all("commands")

-- edkolev/tmuxlineについて
-- tmuxlineはvim/vim-airline/lightline.vimのカラースキームを流用する（？）
-- ところで現在のdotfiles以下の.tmuxline.confは、vim-airlineから生成（:TmuxlineSnapshot）したもの
-- その後vim-airlineは重くてlualineに変更したが、これはtmuxlineが対応していない
-- 過去に生成した.tmuxline.confを引き続き使用するとして、プラグインとしてのtmuxlineは一旦削除の方向で
