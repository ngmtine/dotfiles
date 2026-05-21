-- 表示行単位で上下移動
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- バッファ切替
vim.keymap.set("n", "<Tab>", ":bn<cr>", { silent = true })
vim.keymap.set("n", "<S-Tab>", ":bp<cr>", { silent = true })

-- 検索ハイライト解除
vim.keymap.set("n", "<C-l>", ":<C-u>nohlsearch<cr><C-l>", { silent = true })

-- redo
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank({ timeout = 300 }) end,
})

-- Alt+hjkl のtmux透過移動は plugins.lua の vim-tmux-navigator 側で設定
