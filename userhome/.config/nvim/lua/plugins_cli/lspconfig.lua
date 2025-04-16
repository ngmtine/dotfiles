require("mason").setup({
    ui = { border = "rounded" },
})

require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "ts_ls" },
    automatic_installation = true,
})

require("mason-null-ls").setup({
    ensure_installed = { "biome", "prettierd", "eslint_d" },
    automatic_installation = true,
    handlers = {},
})
