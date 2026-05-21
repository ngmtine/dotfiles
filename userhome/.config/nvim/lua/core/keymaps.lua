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

-- C/D との対称性: Y は行末までyank
vim.keymap.set("n", "Y", "y$")

-- インデント (1打鍵 + 選択維持)
vim.keymap.set("n", "<", "<<")
vim.keymap.set("n", ">", ">>")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- x はyankレジスタを汚さない
vim.keymap.set("n", "x", '"_x', { silent = true })

-- * は次に飛ばず現在語にカーソル維持
vim.keymap.set("n", "*", "*N")

-- cmdline で readline 流の Home/End
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")

-- 全選択
vim.keymap.set("n", "<Leader>a", "ggVG")

-- バッファ閉じる (1つしか開いてなければ enew してから閉じる)
vim.keymap.set("n", "<Leader>x", function()
    local buf = vim.api.nvim_get_current_buf()
    local listed = vim.tbl_filter(function(b)
        return vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted
    end, vim.api.nvim_list_bufs())
    if #listed > 1 then
        vim.cmd("bp")
    else
        vim.cmd("enew")
    end
    vim.api.nvim_buf_delete(buf, {})
end, { desc = "Close buffer" })

-- yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank({ timeout = 300 }) end,
})

-- Alt+hjkl のtmux透過移動は plugins.lua の vim-tmux-navigator 側で設定
