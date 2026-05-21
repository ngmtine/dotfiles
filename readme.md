# minipcブランチ

検証環境minipc用の最低限dotfiles。main にはマージしない。

minipcはWSL上のWindows Terminalから接続するLinux nativeサーバ。
複数端末からssh接続してtmux mainセッションで状態維持する想定。
別ユーザもログインしているが、tmuxのソケットは `/tmp/tmux-$UID/` のため自然に分離される。

## 含めるもの
- `userhome/.bashrc_cmn` — bash共通設定。`ta` aliasでtmux mainセッションへattach/作成
- `userhome/.tmux.conf` + `.tmuxline.conf` + `.local/bin/tmux-window-name.sh` — クリップボードはOSC52
- `userhome/.config/fish/config.fish` — minipc専用に外部依存を排除。`[minipc]` 赤プロンプト + ブランチ表示 (未編集=緑/編集あり=赤/add済み=オレンジ)。push/reset --hard系のabbrは事故防止のため未登録
- `userhome/.config/nvim/` — minipc用の最小Neovim設定。lazy.nvimで vim-tmux-navigator + iceberg + treesitter(v0.9 master固定) + bufferline のみ。Alt+hjklでtmuxペインと透過的に移動。クリップボードはOSC52明示
- `userhome/.gitconfig` — グローバルgit設定。エイリアスは fish abbr で代用するため未収録。ホスト固有 (user.name/email, safe.directory 等) は `~/.gitconfig.local` に分離 (後置 include で local が上書き)
- `userhome/.psqlrc` — psql 用設定。Unicode罫線、レコード毎表示 (`\x on`)、pager=nvim

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
