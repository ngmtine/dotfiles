local null_ls = require("null-ls")
local U = require("U")
local keymap_lsp = require("keymap_lsp")

-- ts, jsのlsp設定
require("lspconfig").ts_ls.setup({
    on_attach = function(client, bufnr)
        -- キーマップ
        keymap_lsp(bufnr)

        -- ts_lsのフォーマット機能を無効化（biome, prettierとの競合回避）
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        -- 保存時フォーマット
        -- vim.api.nvim_create_autocmd("BufWritePre", {
        --     group = vim.api.nvim_create_augroup("biomeFormatting", { clear = true }),
        --     buffer = bufnr,
        --     callback = function()
        --         vim.lsp.buf.format({ async = false })
        --     end,
        -- })
    end
})

local target_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" }

-- 各種設定ファイルの名前（プロジェクトディレクトリ内の探索対象）
local prettier_configs = { ".prettierrc", ".prettierrc.json" }
local eslint_configs = { ".eslintrc", ".eslintrc.json", }
local biome_configs = { "biome.json" }

-- プロジェクトディレクトリに設定ファイルが存在しない場合に代替で使用する設定ファイル
local default_config_dir = vim.fn.stdpath("config")
local default_biome_config = default_config_dir .. "/biome.json"

-- Prettier/ESLintはプロジェクト内での検出に任せるか、デフォルトパスが必要なら定義
-- local default_prettier_config_dir = default_config_dir
-- local default_eslint_config_dir = default_config_dir

-- local get_sources = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

--     if not vim.tbl_contains(target_filetypes, filetype) then
--         return
--     end

--     local sources = {}

--     -- プロジェクト固有の設定ファイルを探す
--     local prettier_config_path = U.find_formatter_config(prettier_configs, bufnr)
--     local eslint_config_path = U.find_formatter_config(eslint_configs, bufnr)
--     local biome_config_path = U.find_formatter_config(biome_configs, bufnr)

--     -- フォーマッター選択 (優先度: biome > prettier)
--     local formatter_args = {}
--     if biome_config_path then
--         -- プロジェクト内にbiome設定ファイルが存在する場合
--         vim.notify("lspconfig-js.lua: Using biome for formatting (project config).")
--         formatter_args = { "--config-path", biome_config_path }
--         table.insert(sources, null_ls.builtins.formatting.biome.with({ extra_args = formatter_args }))
--     elseif prettier_config_path then
--         -- プロジェクト内にprettier設定ファイルが存在する場合
--         vim.notify("lspconfig-js.lua: Using prettierd (project config).")
--         table.insert(sources, null_ls.builtins.formatting.prettierd) -- prettierは通常自動検出するので引数不要なことが多い
--     elseif vim.fn.filereadable(default_biome_config) == 1 then
--         -- プロジェクト内には設定ファイルが存在せず、代替の設定ファイルは存在する場合
--         vim.notify("lspconfig-js.lua: Using biome for formatting (default config).")
--         formatter_args = { "--config-path", default_biome_config }
--         table.insert(sources, null_ls.builtins.formatting.biome.with({ extra_args = formatter_args }))
--     else
--         -- 設定ファイルがどこにも見つからない場合
--         vim.notify("lspconfig-js.lua: Trying biome (no specific config found).")
--         table.insert(sources, null_ls.builtins.formatting.biome) -- 引数なしでbiome実行
--     end

--     -- リンター選択 (優先度: biome > eslint)
--     local linter_args = {}
--     if biome_config_path then
--         -- プロジェクト内にbiome設定ファイルが存在する場合
--         vim.notify("lspconfig-js.lua: Using biome for diagnostics (project config).")
--         linter_args = { "--config-path", biome_config_path }
--         table.insert(sources, null_ls.builtins.diagnostics.biome.with({ extra_args = linter_args }))
--     elseif eslint_config_path then
--         -- プロジェクト内にeslint設定ファイルが存在する場合
--         vim.notify("lspconfig-js.lua: Using eslint_d (project config).")
--         table.insert(sources, null_ls.builtins.diagnostics.eslint_d) -- eslintも自動検出するっぽい
--     elseif vim.fn.filereadable(default_biome_config) == 1 then
--         -- プロジェクト内には設定ファイルが存在せず、代替の設定ファイルは存在する場合
--         vim.notify("lspconfig-js.lua: Using biome for diagnostics (default config).")
--         linter_args = { "--config-path", default_biome_config }
--         table.insert(sources, null_ls.builtins.diagnostics.biome.with({ extra_args = linter_args }))
--     else
--         -- 設定ファイルがどこにも見つからない場合
--         vim.notify("lspconfig-js.lua: Trying eslint_d (no specific config found).")
--         table.insert(sources, null_ls.builtins.diagnostics.eslint_d)
--     end

--     print("sources: " .. sources)
--     return sources
-- end


-- none-lsの設定（各種フォーマッタ用）
null_ls.setup({
    -- sources = get_sources(),

    -- on_attach は設定しない (共通フォーマット関数で処理するため)
    -- on_attach = function(client, bufnr)
    --     if client.supports_method("textDocument/formatting") then
    --         -- vim.api.nvim_clear_autocmds({ group = "biomeFormatting", buffer = bufnr })
    --         -- vim.api.nvim_clear_autocmds({ group = "NoneLsJsTsFormatting", buffer = bufnr })
    --         -- vim.api.nvim_clear_autocmds({ group = "LspFormatOnSave", buffer = bufnr })
    --         local format_augroup = vim.api.nvim_create_augroup("NoneLsFormatOnSave_" .. client.name .. "_" .. bufnr, { clear = true })
    --         vim.api.nvim_create_autocmd("BufWritePre", {
    --             group = format_augroup,
    --             buffer = bufnr,
    --             callback = function()
    --                 vim.lsp.buf.format({ bufnr = bufnr, filter = function(c) return c.id == client.id end, timeout_ms = 3000, async = false })
    --             end,
    --             desc = "Format file using none-ls on save",
    --         })
    --     end
    -- end,


    sources = {
        -- === Formatting ===
        -- 1. Biome (JS/TS/JSON) - biome.json があればこれが使われる (ツール側の挙動)
        null_ls.builtins.formatting.biome.with({
            filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },
            -- extra_args は format_buffer 側で設定ファイルパスが見つかった場合に追加する形も可能だが、
            -- Biomeが自動で見つけることを期待するなら不要かもしれない
        }),
        -- 2. Prettier (JS/TS/JSON/CSS/HTML/MD etc.) - .prettierrc があればこれが使われる (ツール側の挙動)
        null_ls.builtins.formatting.prettierd.with({
            filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "css", "scss", "less", "html", "json", "yaml", "markdown", "graphql" },
        }),
        -- 3. Stylua (Lua)
        -- null_ls.builtins.formatting.stylua.with({
        --     filetypes = {"lua"},
        -- }),
        -- 他のフォーマッタ...

        -- === Diagnostics ===
        -- 1. Biome (JS/TS/JSON)
        -- null_ls.builtins.diagnostics.biome.with({
        --     filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },
        -- }),
        -- -- 2. ESLint (JS/TS/Vue)
        -- null_ls.builtins.diagnostics.eslint_d.with({
        --     filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
        -- }),
        -- -- 他のリンター...
    },
})
