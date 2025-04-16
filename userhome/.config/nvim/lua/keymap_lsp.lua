local map = vim.keymap.set

local saga_cmd = function(cmd)
    return "<cmd>Lspsaga " .. cmd .. "<CR>"
end

-- lsp共通キーマップ
local function keymap_lsp(bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- ホバー情報 (Neovim標準: K)
    opts.desc = "LSP: ホバー情報表示"
    map("n", "K", vim.lsp.buf.hover, opts)

    -- 定義へ移動 (VSCode: F12)
    opts.desc = "LSP: 定義へ移動"
    map("n", "<F12>", vim.lsp.buf.definition, opts)

    -- 定義を覗き見 (VSCode: Alt+F12)
    opts.desc = "LSP: 定義を覗き見 (Lspsaga)"
    -- Alt は <M-...> または <A-...>
    map("n", "<M-F12>", saga_cmd("peek_definition"), opts)
    map("n", "<A-F12>", saga_cmd("peek_definition"), opts) -- 両方設定

    -- 実装へ移動 (VSCode: Ctrl+F12)
    opts.desc = "LSP: 実装へ移動"
    -- map("n", "<C-F12>", vim.lsp.buf.implementation, opts) -- 標準LSP
    map("n", "<C-F12>", saga_cmd("implementation"), opts) -- Lspsaga版 (あれば)

    -- 型定義へ移動 (Neovim標準: gD)
    opts.desc = "LSP: 型定義へ移動"
    map("n", "gD", vim.lsp.buf.type_definition, opts)

    -- 参照を検索 (VSCode: Shift+F12)
    opts.desc = "LSP: 参照を検索"
    -- map("n", "<S-F12>", vim.lsp.buf.references, opts) -- 標準LSP
    map("n", "<S-F12>", saga_cmd("finder"), opts) -- Lspsaga版

    -- リネーム (VSCode: F2)
    opts.desc = "LSP: リネーム"
    map("n", "<F2>", vim.lsp.buf.rename, opts)

    -- コードアクション (VSCode: Ctrl+. => Neovim: <leader>ca 推奨)
    opts.desc = "LSP: コードアクション"
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

    -- 診断: 次へ (VSCode: F8)
    opts.desc = "LSP: 次の診断箇所へ"
    map("n", "<F8>", vim.diagnostic.goto_next, opts)

    -- 診断: 前へ (VSCode: Shift+F8)
    opts.desc = "LSP: 前の診断箇所へ"
    map("n", "<F20>", vim.diagnostic.goto_prev, opts)

    -- 診断: フロート表示 (Neovim標準: <leader>e など)
    opts.desc = "LSP: 診断メッセージ表示"
    map("n", "<leader>e", vim.diagnostic.open_float, opts)

    -- シグネチャヘルプ (VSCode: Ctrl+Shift+Space)
    local insopts = { noremap = true, silent = true, buffer = bufnr }
    insopts.desc = "LSP: シグネチャヘルプ"
    map("i", "<C-S-Space>", vim.lsp.buf.signature_help, insopts) -- <C-S-Space>

    -- シンボルハイライト (変更なし)
    vim.api.nvim_create_autocmd("CursorHold", { buffer = bufnr, callback = vim.lsp.buf.document_highlight, desc = "LSP: シンボルハイライト" })
    vim.api.nvim_create_autocmd("CursorMoved", { buffer = bufnr, callback = vim.lsp.buf.clear_references, desc = "LSP: ハイライト解除" })
end

return keymap_lsp

-- NOTE: 修飾キー押下時のターミナルのキー解釈について
-- 例として、windonws terminalだとs-f12がf20として解釈された
-- （インサートモードでキーを押下すると確認できる）
-- 環境依存の話かもしれないので注意
