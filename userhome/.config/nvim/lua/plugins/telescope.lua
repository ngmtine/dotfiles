local builtin = require 'telescope.builtin'

vim.keymap.set("n", "<c-p>",
    function() builtin.find_files({ hidden = true, file_ignore_patterns = { "node_modules", "git" } }) end)
-- vim.keymap.set("n", "<c-s-p>", builtin.commands) -- なぜか動かない

local actions = require("telescope.actions")
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<C-h>"] = actions.which_key,
                ["<esc>"] = actions.close,
                ["<cr>"] = actions.select_tab,
            },
            n = {
                ["<C-h>"] = actions.which_key,
                ["<esc>"] = actions.close,
                ["<cr>"] = actions.select_tab,
            }
        },
    },
}
