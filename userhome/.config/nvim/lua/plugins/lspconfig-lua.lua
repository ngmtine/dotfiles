local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
local nvim_cmp = require("plugins/nvim-cmp")

mason_lspconfig.setup {
    ensure_installed = { "lua_ls", },
}

lspconfig["lua_ls"].setup({
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
    capabilities = nvim_cmp,
})
