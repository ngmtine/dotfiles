local is_vscode = vim.g.vscode == 1

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- cuiとvscode-neovimの両方で使うプラグイン
local common_plugins = {
    { "norcalli/nvim-colorizer.lua" }, -- カラーコードに背景色つける
    { "preservim/nerdcommenter" },     -- コメントアウト
    { "machakann/vim-sandwich" },      -- vim-surrond的なやつ
    { "monaqa/dial.nvim" },            -- c-a, c-x の強化
    { "cohama/lexima.vim" },           -- 括弧補完
}

-- cuiでのみ使うプラグイン
local cui_plugins = {
    { "cocopon/iceberg.vim" },                                                              -- カラースキーム
    { "nvim-lualine/lualine.nvim",     dependencies = { "kyazdani42/nvim-web-devicons" } }, -- ステータスライン
    { "lambdalisue/suda.vim" },                                                             -- sudo保存
    { "christoomey/vim-tmux-navigator" },                                                   -- nvimとtmuxのペイン移動
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    }
}

function merge_tables(t1, t2)
    local merged = {}
    for _, v in ipairs(t1) do
        table.insert(merged, v)
    end
    for _, v in ipairs(t2) do
        table.insert(merged, v)
    end
    return merged
end

-- プラグイン読み込み
if is_vscode then
    require("lazy").setup(common_plugins)
else
    require("lazy").setup(
        merge_tables(common_plugins, cui_plugins)
    )
end
