-- fzfのパス通しておくことが必要

local act = require("fzf-lua").actions

require("fzf-lua").setup({
    actions = {
        files = {
            ["enter"]  = act.file_edit_or_qf,
            ["ctrl-l"] = act.file_vsplit, -- 右ウィンドウに開く
            ["ctrl-t"] = act.file_vsplit, -- 右ウィンドウに開く
        },
    },

    files = {
        -- previewer = "bat", -- icebergカラースキーム効かないのが嫌
        find_opts = [[-type f \! -path '*/.git/*']], -- 除外ディレクトリ
    }
})

-- キーバインド
vim.keymap.set("n", "<leader>f", "<cmd>lua require('fzf-lua').files()<cr>", { desc = "fzf: ファイル検索" })
vim.keymap.set("n", "<c-p>", "<cmd>lua require('fzf-lua').files()<cr>", { desc = "fzf: ファイル検索" }) -- vscodeと同等
vim.keymap.set("n", "<leader>b", "<cmd>lua require('fzf-lua').buffers()<cr>", { desc = "fzf: バッファ検索" })

