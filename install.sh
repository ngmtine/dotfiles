#!/bin/bash

USERHOME=$(cd $(dirname -- $0); pwd)/userhome
cd $USERHOME

# userhome以下のディレクトリを$HOME以下に生成
for dir in $(ls -dp1 $(find -mindepth 1 -printf "%P\n") | grep  /$)
do
	mkdir -p $HOME/$dir
done

# シンボリックリンク作成
for file in $(ls -dp1 $(find -mindepth 1 -printf "%P\n") | grep -v /$)
do
	ln -snfv $USERHOME/$file $HOME/$file
done

# binディレクトリのコピー
for file in $(ls $(git rev-parse --show-toplevel)/bin)
do
	ln -snfv $(git rev-parse --show-toplevel)/bin/$file /usr/local/bin/$file
done
