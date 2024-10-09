local builtin = require 'telescope.builtin'

vim.keymap.set("n", "<Leader>ff",
    function() builtin.find_files({ hidden = true, file_ignore_patterns = { "node_modules", "git" } }) end)
vim.keymap.set("n", "<Leader>fc", builtin.commands)

local actions = require("telescope.actions")
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<C-h>"] = actions.which_key,
                ["<esc>"] = actions.close,
            },
            n = {
                ["<C-h>"] = actions.which_key,
                ["<esc>"] = actions.close,
            }
        },
    },
}
