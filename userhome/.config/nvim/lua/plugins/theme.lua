pcall(vim.api.nvim_command, "colorscheme iceberg")

vim.opt.termguicolors = true -- truecolor有効化
vim.cmd("hi normal guibg=none") -- 背景色無効（windows terminalで背景色透過）

