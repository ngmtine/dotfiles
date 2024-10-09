-- 警告の下線は鬱陶しいので消す
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = false, underline = false })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = false, underline = false })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = false, underline = false })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = false, underline = false })


-- 保存時フォーマット実行フラグ vim.bはバッファローカル変数
vim.b.isFormatting = true

-- フォーマット実行コマンド
vim.api.nvim_create_user_command("Format", function()
    vim.lsp.buf.format()
end, {})

-- フォーマットせずに保存するコマンド
vim.api.nvim_create_user_command("SaveWithoutFormatting", function()
    vim.b.isFormatting = false
    vim.cmd('write')
    vim.b.isFormatting = true
end, {})
