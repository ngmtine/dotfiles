local lspconfig = require('lspconfig')

-- npm install -g typescript typescript-language-server
lspconfig["tsserver"].setup {
    on_attach = function(client, bufnr)
        -- tsserverのフォーマッタ無効化（biomeを使用するため）
        client.server_capabilities.documentFormattingProvider = false

        -- format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("tsserverFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end,
}

-- npm install -g --save-dev --save-exact @biomejs/biome
lspconfig["biome"].setup {
    on_attach = function(client, bufnr)
        -- import順整理
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("biomeFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.code_action({
                    context = { only = { "source.organizeImports" } },
                    apply = true,
                    filter = function(action)
                        return action.title == "Organize Imports (Biome)"
                    end,
                })
            end,
        })
    end,
}


-- cd ~/.local/bin && mkdir ./lua_ls && cd lua_ls/
-- wget https://github.com/LuaLS/lua-language-server/releases/download/3.10.5/lua-language-server-3.10.5-linux-x64.tar.gz
-- tar xzfv lua-language-server-3.10.5-linux-x64.tar.gz
-- cd ~/.local/bin/ && ln -s ./lua_ls/bin/lua-language-server ./
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
}
