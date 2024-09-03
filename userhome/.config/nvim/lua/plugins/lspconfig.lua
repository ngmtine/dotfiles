local lspconfig = require('lspconfig')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')

mason.setup()

mason_lspconfig.setup({
    ensure_installed = { "tsserver", "biome" }
})

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            on_attach = function(client, bufnr)
                if server_name == "tsserver" then
                    client.server_capabilities.documentFormattingProvider = false
                end

                if server_name == "biome" then
                    client.server_capabilities.documentFormattingProvider = true
                end

                if server_name == "lua-language-server" then
                    client.server_capabilities.documentFormattingProvider = true
                end
            end,
        }
    end,
}

-- js, tsファイルの保存時アクション
local jsgroup = vim.api.nvim_create_augroup("JsFormatOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = jsgroup,
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.mjs", "*.cjs" },
    callback = function()
        -- フォーマット実行
        vim.lsp.buf.format({ async = true })

        -- インポート順整理実行
        vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" } },
            apply = true,
            -- code_actionが複数あるので、実行するcode_actionを名前で特定 NOTE: 複数のcode_actionがある場合、どのcode_actionを実行するのか毎回プロンプトで訊かれるのが手間
            filter = function(action)
                return action.title == "Organize Imports (Biome)"
            end,
        })
    end,
})

-- Luaファイルの保存時アクション
local luagroup = vim.api.nvim_create_augroup("LuaFormatOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = luagroup,
    pattern = "*.lua",
    callback = function()
        -- フォーマット実行
        vim.lsp.buf.format({ async = false })
    end,
})
