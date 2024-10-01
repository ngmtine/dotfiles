-- 開いているファイルのフルパスをコピー
vim.api.nvim_create_user_command("CopyPath", function()
    local filepath = vim.fn.expand('%:p')
    vim.fn.setreg('+', filepath)
    print("Copied file path: " .. filepath)
end, {})
