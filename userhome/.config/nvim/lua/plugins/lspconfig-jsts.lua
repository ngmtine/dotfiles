local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
local nvim_cmp = require("plugins/nvim-cmp")

mason_lspconfig.setup({
    ensure_installed = { "ts_ls", "biome" },
})

lspconfig["ts_ls"].setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true

        -- format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("tsserverFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                if vim.b.isFormatting then
                    vim.lsp.buf.format({ bufnr = bufnr })
                end
            end,
        })
    end,

    -- 補完
    capabilities = nvim_cmp,
})

lspconfig["biome"].setup({
    on_attach = function(client, bufnr)
        -- import順整理
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("biomeFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                if vim.b.isFormatting then
                    vim.lsp.buf.code_action({
                        context = { only = { "source.organizeImports" }, diagnostics = {} },
                        apply = true,
                        filter = function(action)
                            return action.title == "Organize Imports (Biome)"
                        end,
                    })
                end
            end,
        })
    end,
})
