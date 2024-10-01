-- 警告の下線は鬱陶しいので消す
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = false, underline = false })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = false, underline = false })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = false, underline = false })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = false, underline = false })

-- フォーマットせずに保存するコマンド
vim.api.nvim_create_user_command("SaveWithoutFormatting", function()
    vim.b.isFormatting = false
    vim.cmd('write')
    vim.b.isFormatting = true
end, {})
