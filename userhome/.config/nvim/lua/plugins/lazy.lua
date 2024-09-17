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
    { "github/copilot.vim" },             -- copilot
    {
        "CopilotC-Nvim/CopilotChat.nvim", -- copilotchat
        branch = "canary",
        build = "make tiktoken",
        opts = { debug = true, },
    },
    { "nvim-lua/plenary.nvim" },           -- copilotchatの依存
    { "williamboman/mason.nvim" },         -- mason
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },           -- lsp
    { 'hrsh7th/nvim-cmp' },                -- 補完
    { "hrsh7th/cmp-nvim-lsp" },            -- 補完のlspソース
    { 'nvim-treesitter/nvim-treesitter' }, -- treesitter（hlchunk, lspsagaの依存）
    {
        'nvimdev/lspsaga.nvim',            -- lspのUI
        event = { "LspAttach" }
    },
    { "cocopon/iceberg.vim" },            -- カラースキーム
    { "christoomey/vim-tmux-navigator" }, -- nvimとtmuxのペイン移動
    { "monaqa/dial.nvim" },               -- c-a, c-x の強化
    { "norcalli/nvim-colorizer.lua" },    -- カラーコードに背景色つける
    { "preservim/nerdcommenter" },        -- コメントアウト
    { "machakann/vim-sandwich" },         -- vim-surrond的なやつ
    { "lambdalisue/suda.vim" },           -- sudo
    { "kyazdani42/nvim-web-devicons" },   -- アイコン（lualine, lspsagaの依存）
    { "nvim-lualine/lualine.nvim", },     -- ステータスライン
    {
        "shellRaining/hlchunk.nvim",      -- インデントとかの可視化
        event = { "BufReadPre", "BufNewFile" },
    },
}

require("lazy").setup(plugins)
