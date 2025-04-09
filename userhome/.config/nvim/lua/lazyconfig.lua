-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    { "nvim-lua/plenary.nvim" },       -- ユーティリティライブラリ なんかの依存
    { "monaqa/dial.nvim" },            -- c-a, c-x の強化
    { "norcalli/nvim-colorizer.lua" }, -- カラーコードに背景色つける
    { "preservim/nerdcommenter" },     -- コメントアウト
    { "machakann/vim-sandwich" },      -- vim-surrond的なやつ
    { "cohama/lexima.vim" },           -- 括弧補完
    { "cocopon/iceberg.vim" },         -- カラースキーム
    { "williamboman/mason.nvim" },     -- mason
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },       -- lsp
    { "hrsh7th/nvim-cmp" },            -- 補完
    { "hrsh7th/cmp-nvim-lsp" },        -- 補完のlspソース
    { "hrsh7th/cmp-cmdline" },         -- 補完のlspソース
    { "nvimtools/none-ls.nvim" },      -- null-lsフォーク
    {
        "jay-babu/mason-null-ls.nvim", -- masonでnull-lsを使うやつ（sql-formatterの依存）
        event = { "BufReadPre", "BufNewFile" },
    },
    { "nvim-treesitter/nvim-treesitter" },             -- treesitter（hlchunk, lspsagaの依存）
    { "nvim-treesitter/nvim-treesitter-textobjects" }, -- treesitterでテキストオブジェクトを拡張するやつ
    {
        "nvimdev/lspsaga.nvim",                        -- lspのUI
        event = { "LspAttach" }
    },
    { "j-hui/fidget.nvim" },              -- lspの状態通知
    { "mfussenegger/nvim-dap" },          -- dap
    { "jay-babu/mason-nvim-dap.nvim" },   -- masonでdapを使うやつ
    { "rcarriga/nvim-dap-ui" },           -- dapのui
    { "nvim-neotest/nvim-nio" },          -- 非同期APIユーティリティ（nvim-dap-uiの依存）
    { "kyazdani42/nvim-web-devicons" },   -- アイコン（lualine, lspsaga, bufferlineの依存）
    { "nvim-lualine/lualine.nvim" },      -- ステータスライン
    { "christoomey/vim-tmux-navigator" }, -- nvimとtmuxのペイン移動
    { "lambdalisue/suda.vim" },           -- sudo
    {
        "shellRaining/hlchunk.nvim",      -- インデントとかの可視化
        event = { "BufReadPre", "BufNewFile" },
    },
    { "ibhagwan/fzf-lua" },        -- fuzzy finder
    { "akinsho/bufferline.nvim" }, -- バッファをタブエディタっぽく表示するやつ
    {
        "microsoft/vscode-js-debug",
        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
    },
    {
        "mxsdev/nvim-dap-vscode-js",
        dependencies = { "mfussenegger/nvim-dap" },
        opts = {
            -- Masonでインストールしたvscode-js-debugのパス
            -- debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
            debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/",
            -- 登録するアダプターの種類を指定
            adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
            -- ログ
            log_file_path = vim.fn.stdpath("cache") .. "/dap_vscode_js.log",
            -- log_file_level = vim.log.levels.DEBUG,
        },
    },
}

-- プラグイン読み込み
require("lazy").setup(plugins, {
    ui = {
        border = "rounded", -- 枠線
        -- backdrop = 100 -- 効かない（wezterm）
    },
})

-- edkolev/tmuxlineについて
-- tmuxlineはvim/vim-airline/lightline.vimのカラースキームを流用する（？）
-- ところで現在のdotfiles以下の.tmuxline.confは、vim-airlineから生成（:TmuxlineSnapshot）したもの
-- その後vim-airlineは重くてlualineに変更したが、これはtmuxlineが対応していない
-- 過去に生成した.tmuxline.confを引き続き使用するとして、プラグインとしてのtmuxlineは一旦削除の方向で
