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

-- cliとvscodeとで共通して読み込むプラグイン
local plugins = {
    { "nvim-lua/plenary.nvim" },       -- ユーティリティライブラリ なんかの依存
    { "monaqa/dial.nvim" },            -- c-a, c-x の強化
    { "norcalli/nvim-colorizer.lua" }, -- カラーコードに背景色つける
    { "preservim/nerdcommenter" },     -- コメントアウト
    { "machakann/vim-sandwich" },      -- vim-surrond的なやつ
    { "cohama/lexima.vim" },           -- 括弧補完
    { "cocopon/iceberg.vim" },         -- カラースキーム
}

-- vscodeでは読み込まないプラグイン
local cli_only_plugins = {
    -- lsp関係
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    {
        "nvimdev/lspsaga.nvim", -- lspのUI
        event = { "LspAttach" }
    },

    { "nvim-treesitter/nvim-treesitter" },             -- treesitter（hlchunk, lspsagaの依存）
    { "nvim-treesitter/nvim-treesitter-textobjects" }, -- treesitterでテキストオブジェクトを拡張するやつ
    { "j-hui/fidget.nvim" },                           -- lspの状態通知
    { "hrsh7th/nvim-cmp" },                            -- 補完
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-cmdline" },

    -- dap
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
        "mxsdev/nvim-dap-vscode-js", -- dap
        dependencies = { "mfussenegger/nvim-dap" },
    },
}

-- 最終的に読み込むプラグインリストの作成
local is_vscode = vim.g.vscode == 1
if not is_vscode then
    for _, additional in ipairs(cli_only_plugins) do
        table.insert(plugins, additional)
    end
end

-- プラグイン読み込み
require("lazy").setup(plugins, {
    ui = {
        border = "rounded", -- 枠線
        -- backdrop = 100 -- 効かない（wezterm）
    },
})
