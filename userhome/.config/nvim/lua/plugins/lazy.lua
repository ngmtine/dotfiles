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
    -- { "williamboman/mason.nvim" },
    -- { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    { 'hrsh7th/nvim-cmp' },               -- 補完
    { "hrsh7th/cmp-nvim-lsp" },
    { "cocopon/iceberg.vim" },            -- カラースキーム
    { "christoomey/vim-tmux-navigator" }, -- nvimとtmuxのペイン移動
    { "monaqa/dial.nvim" },               -- c-a, c-x の強化
    { "norcalli/nvim-colorizer.lua" },    -- カラーコードに背景色つける
    { "preservim/nerdcommenter" },        -- コメントアウト
    { "machakann/vim-sandwich" },         -- vim-surrond的なやつ
    { "lambdalisue/suda.vim" },           -- sudo
    {
        "nvim-lualine/lualine.nvim",      -- ステータスライン
        dependencies = { "kyazdani42/nvim-web-devicons" }
    },
    -- {
    -- "shellRaining/hlchunk.nvim",
    -- event = { "BufReadPre", "BufNewFile" },
    -- config = function()
    -- require("hlchunk").setup({})
    -- end
    -- },
    { "yaocccc/nvim-hlchunk" }
}

require("lazy").setup(plugins)
