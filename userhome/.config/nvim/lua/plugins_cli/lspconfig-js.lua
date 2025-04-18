local U = require("U")
local G = require("utils/G")
local keymap_lsp = require("keymap_lsp")
local lspconfig = require("lspconfig")

local biome_config_files = { "biome.json" }
local prettier_config_files = { ".prettierrc", ".prettierrc.json" }
local eslint_config_files = { ".eslintrc", ".eslintrc.json", "eslint.config.js" }

-- プロジェクトタイプを判定する関数
local function get_project_type(bufnr)
    local project_type = nil
    local root_dir = U.get_project_root(bufnr)

    local biome_found = nil
    local prettier_found = nil
    local eslint_found = nil

    if root_dir then
        biome_found = U.find_formatter_config(biome_config_files, bufnr) ~= nil
        prettier_found = U.find_formatter_config(prettier_config_files, bufnr) ~= nil
        eslint_found = U.find_formatter_config(eslint_config_files, bufnr) ~= nil

        if biome_found then
            if eslint_found then
                project_type = "biome_eslint"
            else
                project_type = "biome"
            end
        elseif prettier_found then
            if eslint_found then
                project_type = "prettier_eslint"
            else
                project_type = "prettier"
            end
        elseif eslint_found then
            project_type = "eslint"
        end
    end

    local filename = vim.api.nvim_buf_get_name(bufnr)
    local msg = string.format("[efm get_project_type] filename: %s, root_dir: %s, project_type: %s", filename or "unknown", root_dir or "unknown", project_type)
    vim.notify(msg)

    G.project_types[bufnr] = project_type

    return project_type
end

-- efmのsettingsテーブルを動的に構築する関数
local function build_efm_settings()
    local settings = {
        version = 2,
        rootMarkers = { ".git", "package.json" },
        lintDebounce = "500ms",
        languages = {},
    }

    -- 現在のバッファ情報に基づいてプロジェクトタイプを判定
    local bufnr = vim.api.nvim_get_current_buf()
    local project_type = get_project_type(bufnr)

    local tool_config = {}

    -- プロジェクトタイプ毎に設定を変更
    if project_type == "biome" then
        -- Biome
        table.insert(tool_config, {
            lintCommand = "biome check --apply-unsafe --no-errors-on-unmatched ${FILENAME}", -- check コマンド例 (lint と format を含む, ファイルパス渡し)
            -- lintCommand = "biome lint --diagnostic-level=error ${FILENAME}", -- lint のみの場合
            lintFormats = { '%f:%l:%c %t:%*[^:]:%*[^ ] %m' },
            lintStdin = false,
            formatCommand = "biome format --write ${FILENAME}",
            formatStdin = false,
        })
    elseif project_type == "prettier_eslint" then
        -- Prettier
        table.insert(tool_config, {
            formatCommand = "prettier --stdin-filepath ${INPUT}",
            formatStdin = true,
        })
        -- ESLint
        table.insert(tool_config, {
            lintCommand = "eslint --format=compact --stdin --stdin-filename ${INPUT}",
            lintFormats = { '%f:%l:%c: %m [%t/%e]', '%f:%l:%c: %m' },
            lintStdin = true,
        })
    elseif project_type == "prettier" then
        -- Prettier
        table.insert(tool_config, {
            formatCommand = "prettier --stdin-filepath ${INPUT}",
            formatStdin = true,
        })
    end

    -- デフォルト設定
    -- TODO: 今はprettierだけど、何もない場合はdotfilesで管理しているbiome.jsonを使用する形に変更
    if project_type == nil then
        table.insert(tool_config, { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true })
    end

    -- 各言語に構築したツールのリストを割り当て
    settings.languages["javascript"] = tool_config
    settings.languages["typescript"] = tool_config
    settings.languages["javascriptreact"] = tool_config
    settings.languages["typescriptreact"] = tool_config

    -- JSON設定
    settings.languages["json"] = {
        { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true }
    }

    return settings
end

-- 共通on_attach関数
local on_attach = function(client, bufnr)
    vim.notify(string.format("LSP client '%s' attached to buffer %d", client.name, bufnr))
end

-- js, tsのlsp設定
lspconfig.ts_ls.setup({
    on_attach = function(client, bufnr)
        -- キーマップ
        keymap_lsp(bufnr)

        -- ts_lsのフォーマット機能を無効化（efmとの競合回避）
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        -- 保存時フォーマット
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("EfmFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({
                    filter = function(c) return c.name == "efm" end, -- フォーマットはefmに一任
                    async = false
                })
            end,
        })
    end
})

-- efm設定
lspconfig.efm.setup({
    on_attach = on_attach,

    init_options = {
        documentFormatting = true,
        documentRangeFormatting = false,
        documentHighlight = false,
        hover = false,
        completion = false,
    },

    -- プロジェクトがbiome, prettier, eslintのどれを採用しているかによって動的に設定
    settings = build_efm_settings()
})

return {
    get_project_type = get_project_type
}

