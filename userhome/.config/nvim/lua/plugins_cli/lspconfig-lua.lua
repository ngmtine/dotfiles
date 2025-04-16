local keymap_lsp = require("keymap_lsp")

-- luaのlsp設定
require("lspconfig").lua_ls.setup({
    on_attach = function(_, bufnr)
        -- キーマップ
        keymap_lsp(bufnr)

        -- 保存時フォーマット
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("luaFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end,

    -- グローバル変数vimの未定義警告の抑制
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            max_line_length = 200
        },
    },
})
