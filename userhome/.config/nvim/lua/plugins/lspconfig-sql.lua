local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
local null_ls = require("null-ls")
local mason_null_ls = require("mason-null-ls")
local capabilities = require("plugins/nvim-cmp")

mason_lspconfig.setup({
    ensure_installed = { "sqls" },
})

mason_null_ls.setup({
    ensure_installed = { "sql-formatter" },
})

vim.b.isFormatting = true

-- sqlfmtのフォーマッタ設定
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.sql_formatter,
    },
})

lspconfig["sqls"].setup({
    on_attach = function(client, bufnr)
        -- sqlsのフォーマット機能は無効
        client.server_capabilities.documentFormattingProvider = false

        -- format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("sqlsFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                if vim.b.isFormatting then
                    vim.lsp.buf.format({ bufnr = bufnr })
                end
            end,
        })
    end,

    -- 補完
    capabilities = capabilities,
})