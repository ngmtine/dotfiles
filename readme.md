# minipcブランチ

検証環境minipc用の最低限dotfiles。main にはマージしない。

minipcはWSL上のWindows Terminalから接続するLinux nativeサーバ。
複数端末からssh接続してtmux mainセッションで状態維持する想定。
別ユーザもログインしているが、tmuxのソケットは `/tmp/tmux-$UID/` のため自然に分離される。

## 含めるもの
- `userhome/.bashrc_cmn` — bash共通設定。`ta` aliasでtmux mainセッションへattach/作成
- `userhome/.tmux.conf` + `.tmuxline.conf` + `.local/bin/tmux-window-name.sh` — クリップボードはOSC52
- `userhome/.config/fish/config.fish` — minipc専用に外部依存を排除。`[minipc]` 赤プロンプト + ブランチ表示 (未編集=緑/編集あり=赤/add済み=オレンジ)。push/reset --hard系のabbrは事故防止のため未登録

## つかいかた
```sh
bash install.sh   # シンボリックリンクを張る (冪等)
bash cleanup.sh   # 全シンボリックリンクと .bashrc 追記を巻き戻す
```

ssh接続後はおおむね以下のフロー:
```sh
ta        # tmux mainセッション attach (なければ作成)
f         # fish 起動
```
