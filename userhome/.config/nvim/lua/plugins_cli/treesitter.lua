require("nvim-treesitter.configs").setup({
    -- 自動インストールするパーサーのリスト
    ensure_installed = { "vim", "vimdoc", "query", "lua", "javascript", "typescript", "tsx", "python", "markdown" },

    auto_install = true,  -- 自動インストール有効化（tree-sitter-cliがなければfalseにすること）
    sync_install = false, -- 非同期インストール有効化
    ignore_install = {},  -- 自動インストール無視リスト空

    highlight = { enable = true },

    modules = {},

    indent = {
        enable = true,
        disable = { "gitcommit" }, -- FIXME: なんかエラーになるので filetype=gitcommit では無効にする
    },

    -- 選択範囲拡張 TODO: 全く活用できてないしテキストオブジェクトの文字列も適当なのであとで見直す
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    }
})

-- TODO: 関数・クラス・条件文など、構文単位で移動・選択ができる強力機能です
-- これはプラグイン依存（例：nvim-treesitter-textobjects）があるので、必要なときだけ導入でOKです
-- textobjects = {
--     select = {
--         enable = true,
--         lookahead = true,
--         keymaps = {
--             ["af"] = "@function.outer",
--             ["if"] = "@function.inner",
--             ["ac"] = "@class.outer",
--             ["ic"] = "@class.inner",
--         },
--     },
-- }
