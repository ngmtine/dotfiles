local format_on_save_augroup = require("plugins_cli/format")
local keymap_lsp = require("keymap_lsp")

-- luaのlsp設定
require("lspconfig").lua_ls.setup({
    on_attach = function(client, bufnr)
        local msg = string.format("[lspconfig-lua] LSP client '%s' attached to buffer %d", client.name, bufnr)
        vim.notify(msg)

        -- キーマップ
        keymap_lsp(bufnr)

        -- 保存時フォーマット
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = format_on_save_augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        bufnr = bufnr,
                        async = false,
                        filter = function(c) return c.name == "lua_ls" end
                    })
                end,
            })
        end
    end,

    -- グローバル変数vimの未定義警告の抑制
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            max_line_length = 200
        },
    },
})
