require("hlchunk").setup({
    chunk = {
        enable = true,
        chars = {
            horizontal_line = "═",
            vertical_line = "║",
            left_top = "╔",
            left_bottom = "╚",
            right_arrow = "▶",
        },
        duration = 100,
        delay = 100,
        textobject = "ac"
    },
    indent = {
        enable = true,
        duration = 100,
        delay = 100,
    },
    line_num = {
        enable = true,
    },
})
