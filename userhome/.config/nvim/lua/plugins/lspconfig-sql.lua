-- https://qiita.com/lighttiger2505/items/5782debc59ae163a4d81
require("mason-lspconfig").setup {
    ensure_installed = { "sqls", },
}

local lspconfig = require('lspconfig')
local capabilities = require("plugins/nvim-cmp")

lspconfig["sqls"].setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true

        -- format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("sqlsFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end,

    -- 補完
    capabilities = capabilities,
}
