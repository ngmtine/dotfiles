-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
        }, true, {})
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- カラースキーム
    {
        "cocopon/iceberg.vim",
        priority = 1000,
        lazy = false,
        config = function()
            vim.cmd.colorscheme("iceberg")
        end,
    },

    -- tmuxペイン透過移動 (Alt+hjkl)
    -- tmux側は ~/.tmux.conf の bind-key -n 'M-h' ... で is_vim 判定済み
    {
        "christoomey/vim-tmux-navigator",
        init = function()
            vim.g.tmux_navigator_no_mappings = 1
            vim.g.tmux_navigator_save_on_switch = 2
        end,
        keys = {
            { "<A-h>", "<cmd>TmuxNavigateLeft<cr>",  silent = true },
            { "<A-j>", "<cmd>TmuxNavigateDown<cr>",  silent = true },
            { "<A-k>", "<cmd>TmuxNavigateUp<cr>",    silent = true },
            { "<A-l>", "<cmd>TmuxNavigateRight<cr>", silent = true },
        },
    },

    -- シンタックスハイライト
    -- v1.x は API が大きく変わったので、設定が単純な v0.9.x (master) に固定する
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "vim", "vimdoc", "lua", "bash", "markdown", "python" },
                auto_install = true,
                sync_install = false,
                ignore_install = {},
                modules = {},
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- バッファタブ
    { "nvim-tree/nvim-web-devicons" },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    separator_style = "thin",
                },
            })
        end,
    },
}, {
    ui = { border = "rounded" },
})
