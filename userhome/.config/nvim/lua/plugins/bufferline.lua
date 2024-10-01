local bufferline = require('bufferline')

local bgcolor = "#0f1117"

local currentTabBg = "#2a3158"
local currentTabStr = "#cdd1e6"

local otherTabBg = "#1e2132"
local otherTabStr = "#444b71"

bufferline.setup {
    options = {
        mode = "tabs",
        separator_style = "slant", -- タブスタイル
        diagnostics = "nvim_lsp",
    },

    highlights = {
        fill = {
            -- bg = bgcolor, -- タブ行全体の背景色
        },
        background = {
            bg = otherTabBg,  -- 非選択タブの背景色
            fg = otherTabStr, -- 非選択タブの文字色
        },
        -- tab = {
        -- },
        -- tab_selected = {
        -- },
        -- tab_separator = {
        -- },
        -- tab_separator_selected = {
        -- },
        -- tab_close = {
        -- },
        close_button = {
            bg = otherTabBg,
        },
        -- close_button_visible = {
        -- },
        close_button_selected = {
            bg = currentTabBg,
        },
        -- buffer_visible = {
        -- },
        buffer_selected = {
            fg = currentTabStr, -- 選択タブの文字色
            bg = currentTabBg,  -- 選択タブの背景色
            bold = false,
            italic = false,
        },
        -- numbers = {
        -- },
        -- numbers_visible = {
        -- },
        -- numbers_selected = {
        -- bold = false,
        -- italic = false,
        -- },
        -- diagnostic = {
        -- },
        -- diagnostic_visible = {
        -- },
        diagnostic_selected = {
            fg = currentTabStr,
            bg = currentTabBg,
            bold = false,
            italic = false,
        },
        -- hint = {
        -- },
        -- hint_visible = {
        -- },
        hint_selected = {
            fg = currentTabStr, -- lsp起動後の文字色
            bg = currentTabBg,  -- lsp起動後の背景色
            bold = false,
            italic = false,
        },
        -- hint_diagnostic = {
        -- },
        -- hint_diagnostic_visible = {
        -- },
        hint_diagnostic_selected = {
            fg = currentTabStr,
            bg = currentTabBg,
            bold = false,
            italic = false,
        },
        -- info = {
        -- },
        -- info_visible = {
        -- },
        info_selected = {
            bg = currentTabBg,
            bold = false,
            italic = false,
        },
        -- info_diagnostic = {
        -- },
        -- info_diagnostic_visible = {
        -- },
        info_diagnostic_selected = {
            bg = currentTabBg,
            bold = false,
            italic = false,
        },
        -- warning = {
        -- },
        -- warning_visible = {
        -- },
        warning_selected = {
            bg = currentTabBg,
            bold = false,
            italic = false,
        },
        -- warning_diagnostic = {
        -- },
        -- warning_diagnostic_visible = {
        -- },
        warning_diagnostic_selected = {
            bg = currentTabBg,
            bold = false,
            italic = false,
        },
        -- error = {
        -- },
        -- error_visible = {
        -- },
        error_selected = {
            bg = currentTabBg,
            bold = false,
            italic = false,
        },
        -- error_diagnostic = {
        -- },
        -- error_diagnostic_visible = {
        -- },
        error_diagnostic_selected = {
            bg = currentTabBg,
            bold = false,
            italic = false,
        },
        modified = {
            bg = otherTabBg,
        },
        -- modified_visible = {
        -- },
        modified_selected = {
            bg = currentTabBg,
        },
        duplicate_selected = {
            bg = currentTabBg,
            italic = false,
        },
        -- duplicate_visible = {
        -- italic = false,
        -- },
        duplicate = {
            bg = otherTabBg,
            italic = false,
        },
        separator_selected = {
            fg = bgcolor,     -- セパレータの三角形の上部分（選択タブ）
            bg = currentTabBg -- セパレータの三角形の下部分（選択タブ）
        },
        -- separator_visible = {
        -- },
        separator = {
            fg = bgcolor,   -- セパレータの三角形の上部分（非選択タブ）
            bg = otherTabBg -- セパレータの三角形の下部分（非選択タブ）
        },
        -- indicator_visible = {
        -- },
        indicator_selected = {
            bg = currentTabBg,
        },
        pick_selected = {
            bg = currentTabBg,
            bold = false,
            italic = false,
        },
        -- pick_visible = {
        -- bold = false,
        -- italic = false,
        -- },
        pick = {
            bold = false,
            italic = false,
        },
        -- offset_separator = {
        -- },
        trunc_marker = {
            bg = currentTabBg,
        }
    },
}

--[[

highlightが謎
ポストフィックスが何も無いのが選択中のタブ、
_selectedが付いているのが選択されていないタブっぽい
_visibleはよくわからん

]]
