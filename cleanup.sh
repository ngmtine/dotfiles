#!/bin/bash

# install.sh の逆操作スクリプト
# - userhome 配下に対応する $HOME 下のシンボリックリンクを削除
# - .bashrc / .zshrc から `source ~/.bashrc_cmn` の if ブロックを削除
# - ~/.config/fish 配下の壊れたシンボリックリンクを掃除

set -u

BASEDIR=$(cd "$(dirname "$0")" && pwd)
USERHOME="$BASEDIR/userhome"

cd "$USERHOME" || exit 1

# このリポジトリを指すシンボリックリンクのみ削除する
find . -mindepth 1 -not -type d | sed 's|^./||' | while read -r file; do
    target="$HOME/$file"
    if [ -L "$target" ]; then
        link_dest=$(readlink "$target")
        if [ "$link_dest" = "$USERHOME/$file" ]; then
            rm -v "$target"
        else
            echo "skip (different link): $target -> $link_dest"
        fi
    elif [ -e "$target" ]; then
        echo "skip (not a symlink): $target"
    fi
done

# .bashrc / .zshrc から install.sh が追記したブロックを削除
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    [ -f "$rc" ] || continue
    if grep -q "source ~/.bashrc_cmn" "$rc" 2>/dev/null; then
        # if [ -f ~/.bashrc_cmn ]; then ... fi のブロックを削除
        tmp=$(mktemp)
        awk '
            /^if \[ -f ~\/.bashrc_cmn \]; then$/ { skip=1; next }
            skip && /^fi$/ { skip=0; next }
            skip { next }
            { print }
        ' "$rc" > "$tmp"
        # 末尾の連続する空行を1つに圧縮
        sed -i -e :a -e '/^\s*$/{$d;N;ba' -e '}' "$tmp"
        mv "$tmp" "$rc"
        echo "Removed bashrc_cmn source block from $rc"
    fi
done

# ~/.config/fish, ~/.config/nvim 配下の壊れたシンボリックリンクを掃除
for dir in "$HOME/.config/fish" "$HOME/.config/nvim"; do
    [ -d "$dir" ] || continue
    find "$dir" -xtype l -exec rm -v {} \;
done

echo "Cleanup complete."
