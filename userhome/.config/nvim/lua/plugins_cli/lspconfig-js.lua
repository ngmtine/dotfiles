local null_ls = require("null-ls")
local U = require("U")
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

local target_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" }
local prettier_configs = { ".prettierrc", ".prettierrc.json" }
local eslint_configs = { ".eslintrc", ".eslintrc.json", }
local biome_configs = { "biome.json" }

-- none-lsの設定（各種フォーマッタ用）
null_ls.setup({
    -- sources = {
    --     require("null-ls").builtins.formatting.biome.with({
    --         filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    --         extra_args = { "--config-path", vim.fn.expand("~/.config/nvim/biome.json") },
    --     }),
    -- }

    sources = function()
        local sources = {}
        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.bo[bufnr].filetype

        if vim.tbl_contains(target_filetypes, filetype) then
            -- 設定ファイルの存在チェック
            local has_prettier = U.find_formatter_config(prettier_configs, bufnr)
            local has_eslint = U.find_formatter_config(eslint_configs, bufnr)
            local has_biome = U.find_formatter_config(biome_configs, bufnr)

            -- フォーマッター選択 (優先度: Prettier > Biome)
            if has_prettier then
                vim.notify("lspconfig-js.lua: Using prettierd for formatting.")
                table.insert(sources, null_ls.builtins.formatting.prettierd)
            elseif has_biome then
                vim.notify("lspconfig-js.lua: Using biome for formatting (no prettier config found).")
                table.insert(sources, null_ls.builtins.formatting.biome)
            end

            -- リンター選択 (優先度: ESLint > Biome)
            if has_eslint then
                vim.notify("lspconfig-js.lua: Using eslint_d for diagnostics.")
                table.insert(sources, null_ls.builtins.diagnostics.eslint_d)
            elseif has_biome then
                vim.notify("lspconfig-js.lua: Using biome for diagnostics (no eslint config found).")
                table.insert(sources, null_ls.builtins.diagnostics.biome)
            end
        end

        return sources
    end
})
