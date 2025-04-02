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

local common_plugins = {
    { "monaqa/dial.nvim" },            -- c-a, c-x の強化
    { "norcalli/nvim-colorizer.lua" }, -- カラーコードに背景色つける
    { "preservim/nerdcommenter" },     -- コメントアウト
    { "machakann/vim-sandwich" },      -- vim-surrond的なやつ
    { "cohama/lexima.vim" },           -- 括弧補完
}

local cui_plugins = {
    { "cocopon/iceberg.vim" },         -- カラースキーム
    { "nvim-lua/plenary.nvim" },       -- ユーティリティライブラリ（copilotchat, telescopeの依存）
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
    { "nvim-treesitter/nvim-treesitter" }, -- treesitter（hlchunk, lspsagaの依存）
    {
        "nvimdev/lspsaga.nvim",            -- lspのUI
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
    { "nvim-telescope/telescope.nvim" }, -- ファジーファインダー
}

-- プラグイン読み込み
local is_vscode = vim.g.vscode == 1
if is_vscode then
    require("lazy").setup(common_plugins)
else
    require("lazy").setup(
        merge_tables(common_plugins, cui_plugins)
    )
end
