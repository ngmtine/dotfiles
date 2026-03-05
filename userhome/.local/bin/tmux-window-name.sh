#!/usr/bin/env bash
# tmux window名を動的に決定するスクリプト
# 対象windowの最初のペイン(pane index 0)の情報を元に判定する

WINDOW_ID="${1:-$(tmux display-message -p '#{window_id}')}"

# 最初のペイン(index 0)の情報を取得
pane_info=$(tmux list-panes -t "$WINDOW_ID" -F '#{pane_index} #{pane_current_path} #{pane_tty}' | sort -n | head -1)
pane_path=$(echo "$pane_info" | awk '{print $2}')
pane_tty=$(echo "$pane_info" | awk '{print $3}')

if [ -z "$pane_path" ]; then
    echo "shell"
    exit 0
fi

# SSH接続の検出（最優先）
# tmuxのpane_current_commandで直接フォアグラウンドのコマンドを判定
pane_cmd=$(tmux list-panes -t "$WINDOW_ID" -F '#{pane_index} #{pane_current_command}' | sort -n | head -1 | awk '{print $2}')
if [ "$pane_cmd" = "ssh" ] && [ -n "$pane_tty" ]; then
    # sshコマンドラインからホスト名を抽出（最後の非オプション引数）
    ssh_line=$(ps -t "$pane_tty" -o args= 2>/dev/null | grep -E '^\s*ssh\s' | head -1)
    if [ -n "$ssh_line" ]; then
        # オプション引数(-p, -i, -l等)とその値を除去し、最後に残った引数をホストとする
        ssh_host=$(echo "$ssh_line" | sed -E 's/^\s*ssh\s+//' | sed -E 's/-[46AaCfGgKkMNnqsTtVvXxYy]\s*//g; s/-[BbcDEeFIiJLlmOopQRSWw]\s+\S+\s*//g' | awk '{print $1}')
        if [ -n "$ssh_host" ]; then
            # user@host形式からホスト名だけ抽出
            ssh_host=$(echo "$ssh_host" | sed 's/.*@//')
            echo "ssh:$ssh_host"
            exit 0
        fi
    fi
fi

# gitブランチ名を取得
branch=""
repo_name=""
if git -C "$pane_path" rev-parse --is-inside-work-tree &>/dev/null; then
    branch=$(git -C "$pane_path" branch --show-current 2>/dev/null)
    [ -z "$branch" ] && branch=$(git -C "$pane_path" rev-parse --short HEAD 2>/dev/null)
    repo_name=$(basename "$(git -C "$pane_path" rev-parse --show-toplevel 2>/dev/null)")

    # main/developブランチならリポジトリ名を付与
    if [ "$branch" = "main" ] || [ "$branch" = "develop" ]; then
        branch="$repo_name:$branch"
    else
        # プレフィックスを削る
        branch=$(echo "$branch" | sed -E 's|^(feature|hotfix|refactor)/||')
    fi
fi

# dev serverの検出（最初のペインのttyで動いているプロセスを確認）
framework=""
if [ -n "$pane_tty" ]; then
    # pane内の全プロセスを取得
    procs=$(ps -t "$pane_tty" -o args= 2>/dev/null)

    if echo "$procs" | grep -qiE 'next\s+dev|next-server'; then
        framework="Next.js"
    elif echo "$procs" | grep -qiE 'uvicorn|fastapi'; then
        framework="FastAPI"
    elif echo "$procs" | grep -qiE 'vite|nuxt\s+dev'; then
        framework="Vite"
    elif echo "$procs" | grep -qiE 'webpack-dev-server|react-scripts\s+start'; then
        framework="React"
    elif echo "$procs" | grep -qiE 'flask\s+run|FLASK_APP'; then
        framework="Flask"
    elif echo "$procs" | grep -qiE 'rails\s+s|puma'; then
        framework="Rails"
    fi
fi

# 出力の組み立て
if [ -n "$branch" ] && [ -n "$framework" ]; then
    echo "$branch | $framework dev"
elif [ -n "$branch" ]; then
    echo "$branch"
elif [ -n "$framework" ]; then
    echo "$framework dev"
else
    # gitリポジトリ外ならディレクトリ名
    basename "$pane_path"
fi
