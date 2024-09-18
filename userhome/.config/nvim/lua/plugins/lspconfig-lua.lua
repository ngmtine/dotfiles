require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", },
}

local lspconfig = require('lspconfig')
local capabilities = require("plugins/nvim-cmp")

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
