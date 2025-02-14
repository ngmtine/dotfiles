local cmp = require("cmp")

-- 共通キーバインド
local keybindings = {
    -- 補完ウィンドウ表示
    ["<c-space>"] = cmp.mapping.complete(),

    -- 選択中の候補で確定
    ["<cr>"] = cmp.mapping.confirm({ select = true }),

    -- ↓
    ["<down>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        else
            fallback()
        end
    end, { "i", "c", "s" }),

    -- ↓
    ["<tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        else
            fallback()
        end
    end, { "i", "c", "s" }),

    -- ↑
    ["<up>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        else
            fallback()
        end
    end, { "i", "c", "s" }),

    -- ↑
    ["<s-tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        else
            fallback()
        end
    end, { "i", "c", "s" }),

    -- 補完ウィンドウ表示時のescは、入力中の文字列に戻してウィンドウ閉じる
    -- FIXME: ウィンドウ表示されてない通常のインサートモードでのescに待ちが発生する
    -- ["<c-j>"] = cmp.mapping(function(fallback)
    -- if cmp.visible() then
    -- cmp.abort()
    -- else
    -- fallback()
    -- end
    -- end, { "i", "c" }),
}

-- コマンドモードキーバインド
local keybindings_cmdline = vim.tbl_deep_extend("force", keybindings, {
    ["<esc>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            -- 補完ウィンドウ表示時のescは、入力中の文字列に戻してウィンドウ閉じる
            cmp.abort()
        else
            -- 補完ウィンドウが表示されていない時のescは、コマンドモードを抜ける
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, false, true), "n", true)
        end
    end, { "c" }),
})

cmp.setup({
    -- 補完ウィンドウの外見
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    experimental = {
        ghost_text = true, -- 補完候補の文字をエディタ上に薄く表示
    },

    -- 補完ウィンドウが表示された時に一番上の候補を自動選択
    completion = { completeopt = "menu,menuone,noinsert", },

    mapping = cmp.mapping.preset.insert(keybindings),

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
    })
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.insert(keybindings_cmdline),
    sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" }, -- hrsh7th/cmp-cmdline
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.insert(keybindings_cmdline),
    sources = {
        { name = "buffer" }
    }
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

return capabilities
