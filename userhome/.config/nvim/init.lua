local U = require("U")

-- 個別読み込み
U.safe_require("basicconfig")
U.safe_require("keymap")
U.safe_require("lazyconfig")

-- ディレクトリ以下全て読み込み
U.safe_require_all("commands")
U.safe_require_all("plugins")

-- ターミナルでnvimを起動した場合に必要な設定ファイルを読み込む（vscode-neovimとして起動した時に競合するものは読み込まない）
local is_vscode = vim.g.vscode == 1
if not is_vscode then
    U.safe_require_all("plugins_cli")
end
