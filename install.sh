#!/bin/bash

# スクリプトのディレクトリに基づいてuserhomeの絶対パスを取得
# macOSでは'readlink -f'が使えないため、'cd'と'pwd'で代用
# 'dirname -- $0'が'./'を返すことがあるため、'cd'を使用
BASEDIR=$(cd "$(dirname "$0")" && pwd)
USERHOME="$BASEDIR/userhome"

cd "$USERHOME" || exit 1

# userhomeの構造に基づいて$HOME配下にディレクトリを作成
# findの-printfオプションはGNU拡張なので、sedで代用
find . -mindepth 1 -type d | sed 's|^./||' | while read -r dir; do
    mkdir -p "$HOME/$dir"
done

# シンボリックリンクを作成
# findの-printfオプションはGNU拡張なので、sedで代用
find . -mindepth 1 -not -type d | sed 's|^./||' | while read -r file; do
    # 既存のファイルやシンボリックリンクがある場合は上書き
    ln -sfv "$USERHOME/$file" "$HOME/$file"
done

# .bashrc_cmn を展開
# bash向け
BASH_CONFIG_FILE="$HOME/.bashrc"
if ! grep -q "source ~/.bashrc_cmn" "$BASH_CONFIG_FILE" 2>/dev/null; then
    echo "Adding source command to $BASH_CONFIG_FILE"
    echo "" >> "$BASH_CONFIG_FILE"
    echo "if [ -f ~/.bashrc_cmn ]; then" >> "$BASH_CONFIG_FILE"
    echo "    source ~/.bashrc_cmn" >> "$BASH_CONFIG_FILE"
    echo "fi" >> "$BASH_CONFIG_FILE"
fi

# zsh向け
ZSH_CONFIG_FILE="$HOME/.zshrc"
if [ -f "$ZSH_CONFIG_FILE" ]; then
    if ! grep -q "source ~/.bashrc_cmn" "$ZSH_CONFIG_FILE" 2>/dev/null; then
        echo "Adding source command to $ZSH_CONFIG_FILE"
        echo "" >> "$ZSH_CONFIG_FILE"
        echo "if [ -f ~/.bashrc_cmn ]; then" >> "$ZSH_CONFIG_FILE"
        echo "    source ~/.bashrc_cmn" >> "$ZSH_CONFIG_FILE"
        echo "fi" >> "$ZSH_CONFIG_FILE"
    fi
fi


# ~/.config/nvim 配下の壊れたシンボリックリンクを削除
# nvimの設定ディレクトリが存在する場合のみ実行
if [ -d "$HOME/.config/nvim" ]; then
    find "$HOME/.config/nvim" -xtype l -exec rm -v {} \;
fi

echo "Installation complete."