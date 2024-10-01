local cmp = require("cmp")

-- キーバインド設定
local keybindings = {
    ["<C-Space>"] = cmp.mapping.complete(),

    ["<CR>"] = cmp.mapping.confirm({ select = true }),

    ["<Down>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        else
            fallback()
        end
    end, { "i", "c", "s" }),

    ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        else
            fallback()
        end
    end, { "i", "c", "s" }),

    ["<Up>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        else
            fallback()
        end
    end, { "i", "c", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        else
            fallback()
        end
    end, { "i", "c", "s" }),

    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),

    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
}

cmp.setup({
    -- 補完ウィンドウの外見
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    -- 補完ウィンドウが表示された時に一番上の候補を自動選択
    completion = { completeopt = "menu,menuone,noinsert", },

    mapping = cmp.mapping.preset.insert(keybindings),

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
    }, {
        { name = "buffer" },
    })
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.insert(keybindings),
    sources = cmp.config.sources({
        { name = "path" }
    }, {
        { name = "cmdline" }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.insert(keybindings),
    sources = {
        { name = "buffer" }
    }
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

return capabilities
