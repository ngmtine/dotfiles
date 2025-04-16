local keymap_lsp = require("keymap_lsp")

-- ts, jsのlsp設定
require("lspconfig").ts_ls.setup({
    on_attach = function(client, bufnr)
        -- キーマップ
        keymap_lsp(bufnr)

        -- ts_lsのフォーマット機能を無効化（biomeとの競合回避）
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
