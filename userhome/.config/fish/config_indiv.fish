# minipc検証環境専用設定 (本家config.fishの末尾でsourceされる)

# 事故防止: [minipc]赤ラベル付きプロンプトで上書き
functions --erase fish_prompt
function fish_prompt
    set -l red (set_color -o red)
    set -l blue (set_color -o cyan)
    set -l reset (set_color normal)
    echo -n -s $red'[minipc] '$blue(prompt_pwd)$reset' » '
end

# 事故防止: push系とreset --hard系のabbrを削除
abbr --erase ps
abbr --erase psf
abbr --erase rsh
abbr --erase rss

# 本家config.fishにある別ユーザ名hardcoded PATHを除去
set -gx PATH (string match -v '/home/nag/.amp/bin' $PATH)
