-- フォーマット実行関数
local function exec_format(bufnr)
    vim.lsp.buf.format({
        bufnr = bufnr,
        async = false, -- FIXME: 同期フォーマットだと硬直が発生するけどたまにバグるのでしゃあなし
        filter = function(client)
            local filetype = vim.bo[bufnr].filetype
            if filetype == "lua" then
                return client.name == "lua_ls"
            elseif filetype == "javascript" or filetype == "typescript" or filetype == "javascriptreact" or filetype == "typescriptreact" then
                return client.name == "null-ls"
            else
                return true
            end
        end,
        timeout_ms = 2000,
    })
end

-- 保存時自動フォーマット
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
    callback = function(args)
        exec_format(args.buf)
    end,
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
