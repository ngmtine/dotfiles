-- tab補完を無効化
vim.g.copilot_no_tab_map = true

-- Ctrl+fで補完
vim.api.nvim_set_keymap("i", "<C-f>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
