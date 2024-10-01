require("mason-lspconfig").setup {
    ensure_installed = { "ts_ls", "biome" },
}

local lspconfig = require('lspconfig')
local capabilities = require("plugins/nvim-cmp")

-- 保存時フォーマット実行フラグ
vim.b.isFormatting = true

lspconfig["ts_ls"].setup {
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
    capabilities = capabilities,
}

lspconfig["biome"].setup {
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
}

-- フォーマットせずに保存するコマンド
vim.api.nvim_create_user_command("SaveWithoutFormatting", function()
    vim.b.isFormatting = false
    vim.cmd('write')
    vim.b.isFormatting = true
end, {})
