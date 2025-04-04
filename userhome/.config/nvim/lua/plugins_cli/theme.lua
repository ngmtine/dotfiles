pcall(vim.api.nvim_command, "colorscheme iceberg")

-- 背景色無効（windows terminal, weztermで背景色透過）
vim.api.nvim_command("hi normal guibg=none")
