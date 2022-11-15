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
	ln -sfv $USERHOME/$file $HOME/$file
done

# .bashrc_cmnの展開
grep -q "source ~/.bashrc_cmn" ~/.bashrc ;
if [ $? -ne 0 ] ; then
	echo "if [ -f ~/.bashrc_cmn ]; then" >> ~/.bashrc
	echo "source ~/.bashrc_cmn" >> ~/.bashrc
	echo "fi" >> ~/.bashrc
fi
