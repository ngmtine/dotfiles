local format_on_save_augroup = require("plugins_cli/format")
local keymap_lsp = require("keymap_lsp")

local function format_with_beautysh(bufnr)
    -- beautysh コマンドが実行可能か確認
    if vim.fn.executable("beautysh") == 0 then
        vim.notify("beautysh command not found. Please install it (:MasonInstall beautysh)", vim.log.levels.WARN, { title = "Formatting" })
        return
    end

    -- バッファローカルで beautysh を実行
    vim.api.nvim_buf_call(bufnr, function()
        -- カーソル位置を保存
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        -- beautysh コマンド文字列作成
        local cmd = "%!beautysh -"
        vim.cmd(cmd)

        -- beautysh の実行結果を確認
        if vim.v.shell_error ~= 0 then
            -- エラーメッセージに終了コードを追加
            local err_msg = string.format("Failed to format with beautysh. Exit code: %d", vim.v.shell_error)
            vim.notify(err_msg, vim.log.levels.ERROR, { title = "Formatting" })
            vim.cmd("silent undo")
        else
            vim.notify("Formatted buffer " .. bufnr .. " with beautysh", vim.log.levels.INFO, { title = "Formatting" })
        end

        -- カーソル位置を復元
        pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
    end)
end

-- シェルスクリプト (bashls) の LSP 設定
require("lspconfig").bashls.setup({
    on_attach = function(client, bufnr)
        local msg = string.format("[lspconfig] LSP client '%s' attached to buffer %d", client.name, bufnr)
        vim.notify(msg, vim.log.levels.INFO, { title = "LSP Attach" })

        -- 共通のキーマップを設定
        keymap_lsp(bufnr)

        -- シェルスクリプトファイル (*.sh, .bashrc など) を保存する前に beautysh でフォーマットする
        -- bashls 自体は標準でフォーマット機能を提供しないため、client.supports_method はチェックせず、
        -- beautysh がインストールされていればフォーマットを試みる。
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = format_on_save_augroup,
            buffer = bufnr,
            desc = "Format shell script with beautysh on save",
            callback = function()
                format_with_beautysh(bufnr)
            end,
        })
    end,

    filetypes = { "sh", "bash" },
})

vim.notify("bashls LSP configuration loaded.", vim.log.levels.INFO, { title = "LSP Setup" })
