require("hlchunk").setup({
    chunk = {
        enable = true,
        use_treesitter = true,
        chars = {
            horizontal_line = "═",
            vertical_line = "║",
            left_top = "╔",
            left_bottom = "╚",
            right_arrow = "▶",
        },
        duration = 100,
        delay = 100,
        textobject = "ac",
    },
    indent = {
        enable = true,
        use_treesitter = true,
        duration = 80,
        delay = 80,
    },
    line_num = {
        enable = true,
        use_treesitter = true,
    },
})
