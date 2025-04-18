local G = require("utils/G")

local function get_project_type()
    local bufnr = vim.api.nvim_get_current_buf()
    local project_type = G.project_types[bufnr]

    if not project_type then
        return ""
    end

    return string.format("🛠️ %s", project_type)
end

require("lualine").setup({
    sections = {
        lualine_x = { "diagnostics", get_project_type, "encoding", "fileformat", "filetype" },
    },
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("UpdateProjectCacheOnEnter", { clear = true }),
    callback = function(args)
        -- lualine を強制的に再描画させたい場合 (通常は不要かも)
        require("lualine").refresh()
    end,
})

-- require("lualine").setup()

local lspconfig_js = require("plugins_cli/lspconfig-js")

-- BufEnter イベントでプロジェクトタイプ判定とキャッシュ更新をトリガー
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*", -- すべてのバッファに入る時
    group = vim.api.nvim_create_augroup("UpdateProjectTypeCacheOnEnter", { clear = true }),
    callback = function(args)
        -- ファイル名がある有効なバッファのみ
        if vim.api.nvim_buf_is_valid(args.buf) and vim.api.nvim_buf_get_name(args.buf) ~= "" then
            -- 少し遅延させて実行
            vim.defer_fn(function()
                -- lspconfig-js モジュール内の get_project_type を呼び出してキャッシュを更新
                lspconfig_js.get_project_type(args.buf)
            end, 50) -- 50ミリ秒遅延
        end
    end,
    desc = "Update project type cache when entering a buffer",
})
