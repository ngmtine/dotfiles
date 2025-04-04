-- lspメッセージ表示プラグイン
require("fidget").setup({
    notification = {
        window = {
            winblend = 0,      -- 背景色透過率
            border = "single", -- "none"|"single"|"double"|"rounded"|"solid"|"shadow"|string[]
        },
    },
})
