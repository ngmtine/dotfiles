-- エラーを出さずにrequireする関数
local function safe_require(module)
    local ok, ret = pcall(require, module)
    if not ok then
        print("require failed: " .. module)
    end
    return ret
end

-- 渡されたディレクトリ直下のluaを全てrequireする関数（現状は再帰なし 再帰の方が便利かも）
local function require_all(dir)
    local command_dir = vim.fn.stdpath("config") .. "/lua/" .. dir
    for _, file in ipairs(vim.fn.readdir(command_dir)) do
        if file:match("%.lua$") then
            local module = dir:gsub("/", ".") .. "." .. file:gsub("%.lua$", "")
            safe_require(module)
        end
    end
end

-- 個別読み込み
safe_require("basicconfig")
safe_require("keymap")
safe_require("lazyconfig")

-- ディレクトリ以下全て読み込み
require_all("commands")
require_all("plugins")

-- ターミナルでnvimを起動した場合に必要な設定ファイルを読み込む（vscode-neovimとして起動した時に競合するものは読み込まない）
local is_vscode = vim.g.vscode == 1
if not is_vscode then
    safe_require("masonconfig")
    require_all("plugins_cli")
end
