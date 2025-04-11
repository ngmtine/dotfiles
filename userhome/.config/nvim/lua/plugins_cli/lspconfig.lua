require("mason").setup({
    ui = {
        border = "rounded",
    },
})

require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "ts_ls" },
    automatic_installation = true,
})

require("mason-null-ls").setup({
    ensure_installed = { "biome" },
    automatic_installation = true,
    handlers = {},
})

-- luaのlsp設定
require("lspconfig").lua_ls.setup({
    on_attach = function(_, bufnr)
        -- 保存時フォーマット
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("luaFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end,

    -- グローバル変数vimの未定義警告の抑制
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } }
        },
    },
})

-- ts, jsのlsp設定
require("lspconfig").ts_ls.setup({
    on_attach = function(client, bufnr)
        -- ts_lsのフォーマット機能を無効化し、Biomeとの競合を避ける
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        -- 保存時フォーマット
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("biomeFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end
})

-- none-lsの設定（biome用）
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.biome.with({
            filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
            extra_args = { "--config-path", vim.fn.expand("~/.config/nvim/biome.json") },
        }),
    },
})

-- フォーマット関係の設定 ------------------------------

-- 共通フォーマット処理関数
local function exec_format(bufnr)
    vim.lsp.buf.format({
        bufnr = bufnr,
        async = false, -- 同期フォーマットだと硬直が発生するけどたまにバグるのでしゃあなし
        filter = function(client)
            local filetype = vim.bo[bufnr].filetype
            if filetype == "lua" then
                return client.name == "lua_ls"
            elseif filetype == "javascript" or filetype == "typescript" or filetype == "javascriptreact" or filetype == "typescriptreact" then
                return client.name == "null-ls"
            else
                return true
            end
        end,
        timeout_ms = 2000,
    })
end

-- 保存時自動フォーマット
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
    callback = function(args)
        exec_format(args.buf)
    end,
})

-- 手動フォーマットコマンド
vim.api.nvim_create_user_command(
    "Format",
    function()
        exec_format(vim.api.nvim_get_current_buf())
    end,
    {
        nargs = 0,
        desc = "現在のバッファをフォーマットします",
    }
)

-- 自動フォーマットなしで保存するコマンド
vim.api.nvim_create_user_command(
    "SaveWithoutFormat",
    "noautocmd write",
    {
        nargs = 0,
        bang = true,
        desc = "フォーマットを実行せずに現在のバッファを保存します",
    }
)

-- TODO: jsのフォーマッタにbiomeだけでなくprettier, eslintの設定も追加する
-- TODO: 硬直の解決策わからんけど非同期フォーマットに変更したい
