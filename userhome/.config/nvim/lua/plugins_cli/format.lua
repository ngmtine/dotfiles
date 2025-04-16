-- フォーマット実行関数
-- local function exec_format(bufnr)
--     vim.lsp.buf.format({
--         bufnr = bufnr,
--         async = false, -- FIXME: 同期フォーマットだと硬直が発生するけどたまにバグるのでしゃあなし
--         filter = function(client)
--             local filetype = vim.bo[bufnr].filetype
--             if filetype == "lua" then
--                 return client.name == "lua_ls"
--             elseif filetype == "javascript" or filetype == "typescript" or filetype == "javascriptreact" or filetype == "typescriptreact" then
--                 return client.name == "null-ls"
--             else
--                 return true
--             end
--         end,
--         timeout_ms = 2000,
--     })
-- end

-- 保存時自動フォーマット
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
--     callback = function(args)
--         exec_format(args.buf)
--     end,
-- })

local function exec_format(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

    local format_opts = {
        bufnr = bufnr,
        timeout_ms = 3000,
        async = false -- 保存時なので同期
    }

    print(string.format("[Format] Attempting format for filetype: '%s'", filetype or "nil"))

    -- [[ ★★★ filter ロジックを簡略化 ★★★ ]]
    if filetype == "lua" then
        -- Lua の場合は lua_ls を優先 (none-ls で stylua を設定していない場合)
        print("[Format] Filtering for 'lua_ls' client.")
        format_opts.filter = function(client) return client.name == "lua_ls" end
    else
        -- Lua 以外は none-ls に任せる
        -- none-ls 内部で filetypes と sources の順序に基づいて適切なソースが選択されることを期待
        print("[Format] Filtering for 'null-ls' client.")
        format_opts.filter = function(client) return client.name == "null-ls" end -- クライアント名は "null-ls"
    end

    -- vim.lsp.buf.format を実行
    -- pcall でラップしてエラーが発生しても Neovim が停止しないようにする
    local success, result = pcall(vim.lsp.buf.format, format_opts)

    if success then
        print("[Format] vim.lsp.buf.format call succeeded.")
        -- フォーマットが実際に適用されたかは result では判断できない場合がある
        vim.notify("Formatted buffer " .. bufnr, vim.log.levels.INFO) -- 必要なら通知
    else
        print(string.format("[Format] vim.lsp.buf.format call failed for filetype '%s': %s", filetype or "nil", tostring(result)))
        vim.notify(string.format("Formatting failed: %s", tostring(result)), vim.log.levels.WARN)
    end
end

-- 保存時自動フォーマット
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
    pattern = "*",
    callback = function(args)
        exec_format(args.buf)
    end,
    desc = "Format buffer before saving using LSP/none-ls",
})



-- 手動フォーマットコマンド
vim.api.nvim_create_user_command(
    "Format",
    function()
        exec_format(vim.api.nvim_get_current_buf())
    end,
    {
        nargs = 0,
        desc = "現在のバッファをフォーマットします",
    }
)

-- 自動フォーマットなしで保存するコマンド
vim.api.nvim_create_user_command(
    "SaveWithoutFormat",
    "noautocmd write",
    {
        nargs = 0,
        bang = true,
        desc = "フォーマットを実行せずに現在のバッファを保存します",
    }
)

-- 別にプラグイン設定とかではないけどcliでのみ効かせたい設定なのでplugins_cliに設置した
