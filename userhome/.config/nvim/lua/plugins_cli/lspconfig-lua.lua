local lspconfig = require("lspconfig")
local nvim_cmp = require("plugins_cli/nvim-cmp")

lspconfig["lua_ls"].setup({
    cmd = { "lua-language-server" },
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("luaFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                if vim.b.isFormatting then
                    -- フォーマット実行
                    vim.lsp.buf.format({ async = false })
                end
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

-- mason_lspconfig.setup_handlers({ function(server_name)
-- require("lspconfig")[server_name].setup {}
-- end,
-- })
