require("mason").setup({
    ui = { border = "rounded" },
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "ts_ls",
        "efm" -- biome, prettier, eslint用
    },
    automatic_installation = true,
})
