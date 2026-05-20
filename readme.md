# minipcブランチ

検証環境minipc用の最低限dotfiles。main にはマージしない。

## 含めるもの
- `userhome/.bashrc_cmn` (WSL固有エッジを除去済み)
- `userhome/.tmux.conf` + `.tmuxline.conf` + `.local/bin/tmux-window-name.sh`
- `userhome/.config/fish/config.fish` (本家のまま)
- `userhome/.config/fish/config_indiv.fish` (minipc専用上書き: [minipc]赤プロンプト、push/reset abbr削除、別ユーザPATH除去)

## つかいかた
```
bash install.sh
```
でディレクトリ構成保ったままシンボリックリンクを張る。
