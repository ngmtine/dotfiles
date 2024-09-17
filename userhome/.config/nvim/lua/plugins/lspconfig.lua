local lspconfig = require('lspconfig')
local capabilities = require("plugins/nvim-cmp")

-- 警告の下線は鬱陶しいので消す
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = false, underline = false })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = false, underline = false })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = false, underline = false })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = false, underline = false })

lspconfig["ts_ls"].setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true

        -- format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("tsserverFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
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
                vim.lsp.buf.code_action({
                    context = { only = { "source.organizeImports" }, diagnostics = {} },
                    apply = true,
                    filter = function(action)
                        return action.title == "Organize Imports (Biome)"
                    end,
                })
            end,
        })
    end,
}

lspconfig["lua_ls"].setup {
    cmd = { "lua-language-server" },
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("luaFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                -- フォーマット実行
                vim.lsp.buf.format({ async = false })
            end,
        })
    end,

    -- https://github.com/neovim/neovim/issues/21686
    settings = {
        Lua = {
            workspace = {
                -- "undefined global vim" 警告の抑制
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },

    -- 補完
    capabilities = capabilities,
}
