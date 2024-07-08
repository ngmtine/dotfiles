-- map leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- keymap
vim.keymap.set("n", "<tab>", "gt")
vim.keymap.set("n", "<s-tab>", "gT")
vim.keymap.set("n", "<s-y>", "y$")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("i", "<c-a>", "<c-o>^")
vim.keymap.set("i", "<c-e>", "<esc>$i<right>")
vim.keymap.set("i", "<c-k>", "<esc><right>d$i")
vim.keymap.set("n", "U", "<c-r>")
vim.keymap.set("n", "<", "<<")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("n", ">", ">>")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("n", "<c-l>", ":<c-u>nohlsearch<cr><c-l>")
vim.keymap.set("c", "<c-a>", "<home>")
vim.keymap.set("c", "<c-e>", "<end>")
vim.keymap.set("n", "*", "*N")

-- leader keymap
vim.keymap.set("n", "<Leader>rep", '"_dw"+P')
vim.keymap.set("v", "<Leader>rep", '"_d"+P')
vim.keymap.set("n", "<Leader>a", "ggVG")

