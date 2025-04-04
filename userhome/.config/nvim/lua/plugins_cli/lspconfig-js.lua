local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local nvim_cmp = require("plugins_cli/nvim-cmp")

lspconfig["ts_ls"].setup({
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = true
    end,
    capabilities = nvim_cmp,
})

lspconfig["biome"].setup({
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = true
    end,
})

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier.with({
            command = "prettier",
        }),
    },
})

-- Biomeによるフォーマットとインポート整理
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.js", "*.mjs", "*.cjs", "*.jsx", "*.ts", "*.tsx", "*.json" },
    group = vim.api.nvim_create_augroup("BiomeFormatOnSave", { clear = true }),
    callback = function()
        if vim.b.isFormatting then
            -- インポート整理
            vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports" }, diagnostics = {} },
                apply = true,
                filter = function(action)
                    return action.title == "Organize Imports (Biome)"
                end,
            })

            -- フォーマット
            local bufnr = vim.api.nvim_get_current_buf()
            vim.lsp.buf.format({ bufnr = bufnr, async = true })
        end
    end,
})

-- Prettierによるフォーマット
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.html", "*.css", "*.md" },
    group = vim.api.nvim_create_augroup("PrettierFormatOnSave", { clear = true }),
    callback = function()
        if vim.b.isFormatting then
            local bufnr = vim.api.nvim_get_current_buf()
            vim.lsp.buf.format({ bufnr = bufnr, async = true })
        end
    end,
})
