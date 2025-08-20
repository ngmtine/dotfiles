# fishをログインシェルにすることは想定していません
# PATH等は ~/.bashrc 側で設定すること

# 右側の時刻表示削除
functions --erase fish_right_prompt

# 基本
export EDITOR="/usr/bin/nvim"

# wsl判定
function is_wsl
  [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]
end

# truecolor有効化
# https://fishshell.com/docs/current/cmds/set_color.html
set -g fish_term24bit 1

# fish settings -------------------------------------
set -g theme_color_scheme base16-light
set -g theme_display_docker_machine yes
set -g theme_display_virtualenv yes
set -g theme_nerd_fonts yes
set -g theme_title_use_abbreviated_path no
set -g theme_newline_cursor yes
set -g theme_newline_prompt '$ '
set -g theme_display_git_master_branch yes # masterでもブランチ名を表示
set -g theme_display_cmd_duration yes # コマンドの実行時間を表示
set -g theme_show_exit_status yes # exitステータスを表示
set -g fish_prompt_pwd_dir_length 0 # ディレクトリ名を省略しない
set -g theme_git_worktree_support yes # リポジトリの場合はブランチ表示

# alias ----------------------------------------
# 基本
abbr -a vi nvim
abbr -a view nvim -R
abbr -a :q exit
abbr -a cd pushd
abbr -a po popd
abbr -a cdrr 'pushd (git rev-parse --show-toplevel)'
abbr -a ll ls -lah
abbr -a l1 ls -1
abbr -a lx "ls -1 | xargs -n1 "
abbr -a cp cp -rp
abbr -a scp scp -rp
abbr -a ydl youtube-dl -f bestvideo+bestaudio --merge-output-format mp4
abbr -a x xargs
abbr -a f fzf --exit-0 | xargs -r
abbr -a vs code

if is_wsl
    abbr -a e explorer.exe
    abbr -a yank win32yank.exe -i
    abbr -a ff '"/mnt/c/Program Files/Mozilla Firefox/firefox.exe"'
else
    abbr -a e nautilus
    abbr -a yank xsel --input --clipboard
end

# git
abbr -a g git
abbr -a gin "git init && echo node_modules >> .gitignore"
abbr -a gad git add
abbr -a gada git add --all
abbr -a gcm git commit
abbr -a gcma git commit --amend
abbr -a gcman git commit --amend --no-edit
abbr -a grb git rebase -i
abbr -a grbc git rebase --continue
abbr -a grba git rebase --abort
abbr -a gps git push
abbr -a gpsf git push --force
abbr -a gpl git pull
abbr -a gcl git clone
abbr -a gco git checkout
abbr -a gcob git checkout -b
abbr -a gbr git branch
abbr -a gs git status -s
abbr -a gfe git fetch
abbr -a gmr git merge
abbr -a glg git log --pretty="'format:%C(yellow)%h %C(green)%cd %C(cyan)[%an] %C(reset)%s %C(red)%d'" --date="'format:%Y-%m-%d %H:%M:%S'" --graph --branches --remotes --tags
abbr -a gdf git diff
abbr -a gdfn git diff --name-only
# 要 git config --global diff.tool nvimdiff
abbr -a gdft git difftool
# abbr -a --command git co checkout # 何故か効かない

# docker
abbr -a d docker
abbr -a di docker image
abbr -a dil docker image ls
abbr -a dc docker container
abbr -a dcl docker container ls -a
abbr -a dn docker network
abbr -a ds docker system
abbr -a --set-cursor=% deb docker exec -it % /bin/bash
abbr -a co docker compose
abbr -a cou docker compose up
abbr -a cod docker compose down

# tmux
abbr -a tlh tmux select-layout even-horizontal
abbr -a tlv tmux select-layout even-vertical
# tmux使うとvscodeのターミナルからvscodeに送るやつが壊れるやつの対応
abbr -a recode export VSCODE_IPC_HOOK_CLI=

# ghq
abbr -a gg ghq get -p
abbr -a gl ghq list --full-path

# fzf
abbr -a fn 'find . -type f -not -path "**/node_modules/*" -not -path "**/.git/*" -not -path "**/.docker/*" | fzf --reverse --exit-0 | xargs -r nvim'
abbr -a fr 'pushd (ghq list -p | fzf --reverse --exit-0)'

# color setting -------------------------------------
set -l crow       121421 #121421
set -l bluegrey   282c44 #282c44
set -l bluegrey_  3d415d #3d415d
set -l bluegrey__ 74778c #74778c
set -l icegrey    c7c9d1 #c7c9d1
set -l lavender   a191c9 #a191c9
set -l hyacinthus 859fc8 #859fc8
set -l lightblue  89b8c1 #89b8c1
set -l wasabi     b7c685 #b7c685
set -l apricot    e3a676 #e3a676
set -l coralred   e27a79 #e27a79

# set -g fish_color_operator 91acd1 #91acd1
# set -g fish_color_error 6b6f86 #6b6f86 

set -l fish_color_normal $icegrey

# https://fishshell.com/docs/current/interactive.html?highlight=fish_color_operator

set -g fish_color_normal $icegrey	# default color
set -g fish_color_command $hyacinthus # commands like echo
set -g fish_color_keyword $hyacinthus	# keywords like if - this falls back on the command color if unset
set -g fish_color_quote $lightblue	# quoted text like "abc"
set -g fish_color_redirection $wasabi	# IO redirections like >/dev/null
set -g fish_color_end $wasabi	# process separators like ; and &
set -g fish_color_error	$bluegrey__ # syntax errors
set -g fish_color_param $lightblue	# ordinary command parameters
set -g fish_color_option $wasabi	# options starting with “-”, up to the first “--” parameter
set -g fish_color_comment $wasabi	# comments like ‘# important’
# set -g fish_color_selection	# selected text in vi visual mode
set -g fish_color_operator $lightblue	# parameter expansion operators like * and ~
set -g fish_color_escape $lightblue	# character escapes like \n and \x70
# set -g fish_color_autosuggestion	# autosuggestions (the proposed rest of a command)
# set -g fish_color_cwd	# the current working directory in the default prompt
# set -g fish_color_user	# the username in the default prompt
# set -g fish_color_host	# the hostname in the default prompt
# set -g fish_color_host_remote	# the hostname in the default prompt for remote sessions (like ssh)
# set -g fish_color_cancel	# the ‘^C’ indicator on a canceled command
# set -g fish_color_search_match	# history search matches and selected pager items (background only)

# カラーテーマ読み込み
bobthefish_colors

# viモードなーんか微妙だったのでコメントアウト
# fish_vi_key_bindings 
# set fish_cursor_default     block      blink
# set fish_cursor_insert      line       blink
# set fish_cursor_replace_one underscore blink
# set fish_cursor_visual      block

function greprep
	if test (count $argv) -ne 2 ;
		echo 引数が2つじゃないよ
		return
	end
	
	echo ファイル中身置換 --------------
	grep -rl $argv[1] --exclude-dir=.git
	echo 上記の $argv[1] を $argv[2] へ置換します
	echo "実行しますか?(y/N): " ; read ans ; if test "$ans" != "y" ; echo 中止しました ; return ; else ; echo 実行します
		grep -rl $argv[1] --exclude-dir=.git | xargs sed -i "s/$argv[1]/$argv[2]/g"
	end
	echo 

	echo ファイル名置換 ------------------
	find . -name "*$argv[1]*" | sed -E "p;s/$argv[1]/$argv[2]/" | xargs -n2 echo
	echo 上記を置換します
	echo "実行しますか?(y/N): " ; read ans ; if test "$ans" != "y" ; echo 中止しました ; return ; else ; echo 実行します
		find . -name "*$argv[1]*" | sed -E "p;s/$argv[1]/$argv[2]/" | xargs -n2 mv
	end
	echo 

end

function yntest
	echo "実行しますか?(y/N): " ; read ans ; if test "$ans" != "y" ; echo 中止しました ; return ; else ; echo 実行します
	# ここに処理を書く
	end
end

# ただのcatのラッパー
function nya
    if test (count $argv) -gt 0
        for file in $argv
            if test -f "$file"
                echo "---"
                echo "# $file"
                echo ""
                cat "$file"
                echo ""
            end
        end
    end
end

# fzfでファイルを選択してnyaで表示する関数
function nyaf
    # 検索コマンド初期化
    set find ""

    if command -v fdfind > /dev/null
        set find fdfind --type f --hidden
    else
        set find find . -type f
    end

    if test -z "$find"
        echo "エラー: ファイル検索コマンドが見つかりません (fdfind, fd, find)" >&2
        return 1
    end

    # $findの結果をfzfにパイプしてnyaに渡す
    if $find | fzf --reverse --multi --preview "nya {}" | read -z -a selected_files
        if test (count $selected_files) -gt 0
            nya $selected_files
        else
            commandline -f repaint
        end
    else
      commandline -f repaint
    end
end

# git difftoolのラッパー関数
# ~/.gitconfigに以下を追加しておくこと
# [difftool "vscode"]
#     cmd = code --wait --diff $LOCAL $REMOTE
function vsd

    # gitリポジトリ外なら終了
    set -l repo_root (git rev-parse --show-toplevel)
    if not test $status -eq 0
        echo "Error: Not a git repository." >&2
        return 1
    end

    # diffのあるファイルリストを取得
    set -l files (git diff --name-only $argv)
    if not set -q files[1]
        return
    end

    for file in $files
        set -l absolute_path "$repo_root/$file"
        # git difftoolにコミット指定($argv)とファイルパス(-- "$absolute_path")を渡す
        echo $absolute_path
        git difftool --no-prompt $argv -- "$absolute_path" &
        disown
    end
end

# 個別設定読み込み
if test -f $__fish_config_dir/config_indiv.fish
	source $__fish_config_dir/config_indiv.fish
end

