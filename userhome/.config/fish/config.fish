# minipc検証環境用の fish 設定
# fishをログインシェルにすることは想定していない。PATH等は ~/.bashrc 側で設定する

# 右側の時刻表示削除
functions --erase fish_right_prompt

# 基本
set -gx EDITOR /usr/bin/nvim

# truecolor有効化
# https://fishshell.com/docs/current/cmds/set_color.html
set -g fish_term24bit 1
set -gx COLORTERM truecolor

# ディレクトリ名を省略しない
set -g fish_prompt_pwd_dir_length 0

# プロンプト ----------------------------------------
# [minipc] cwd (branch) »
#   branch色: 未編集=緑 / 編集あり=赤 / add済み=オレンジ
function fish_prompt
    set -l red (set_color -o red)
    set -l blue (set_color -o cyan)
    set -l reset (set_color normal)

    echo -n -s $red'[minipc] '$blue(prompt_pwd)$reset

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l branch (git symbolic-ref --short HEAD 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)
        if test -n "$branch"
            set -l untracked (git ls-files --others --exclude-standard 2>/dev/null)
            set -l git_color
            if git diff --quiet HEAD -- 2>/dev/null; and test (count $untracked) -eq 0
                set git_color (set_color -o green)
            else if not git diff --quiet -- 2>/dev/null; or test (count $untracked) -gt 0
                set git_color (set_color -o red)
            else
                set git_color (set_color -o FFA500)
            end
            echo -n -s ' '$git_color'('$branch')'$reset
        end
    end

    echo -n -s ' » '
end

# abbr ----------------------------------------
# 基本
abbr -a vi nvim
abbr -a ゔぃ nvim
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
abbr -a x xargs
abbr -a f fzf --exit-0 | xargs -r

# known_hostsを見ないssh (明示名なので事故は起きにくい)
alias ssh-unsafe='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias scp-unsafe='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# git
# 事故防止: push --force (psf) と reset --hard (rsh) は引き続き未登録
# push は ps、強制 push は --force-with-lease の pf を採用
abbr -a g git
abbr --add --command git co checkout
abbr --add --command git a add
abbr --add --command git aa add -A
abbr --add --command git cm commit
abbr --add --command git cma commit --amend
abbr --add --command git s status
abbr --add --command git ss status -s
abbr --add --command git lg log
abbr --add --command git df diff
abbr --add --command git br branch
abbr --add --command git pl pull
abbr --add --command git fe fetch
abbr --add --command git mg merge
abbr --add --command git cp cherry-pick
abbr --add --command git rb rebase
abbr --add --command git rbi rebase -i
abbr --add --command git rba rebase --abort
abbr --add --command git rbc rebase --continue
abbr --add --command git cl clone
abbr --add --command git sw switch
abbr --add --command git swc switch -c
abbr --add --command git sh show
abbr --add --command git bl blame
abbr --add --command git rl reflog
abbr --add --command git rh reset HEAD
abbr --add --command git rs restore --staged
abbr --add --command git lo log --oneline
abbr --add --command git lol log --oneline --graph --all
abbr --add --command git sta stash
abbr --add --command git stp stash pop
abbr --add --command git stl stash list
abbr --add --command git wt worktree
abbr --add --command git wta worktree add
abbr --add --command git wtl worktree list
abbr --add --command git wtr worktree remove
abbr --add --command git ps push
abbr --add --command git pf push --force-with-lease
abbr --add --command git dc diff --cached
abbr --add --set-cursor=% --command git cmm 'commit -m "%"'
abbr --add --command git cane commit --amend --no-edit
abbr --add --command git rs reset
abbr --add --command git rss reset --soft

# glab (top-level)
abbr -a gl glab

# docker
abbr -a d docker
abbr --add --command docker i image
abbr --add --command docker il 'image ls'
abbr --add --command docker ir 'image rm'
abbr --add --command docker c container
abbr --add --command docker cl 'container ls -a'
abbr --add --command docker cr 'container rm'
abbr --add --command docker n network
abbr --add --command docker s system
abbr --add --command docker sp 'system prune'
abbr --add --command docker r 'run -it'
abbr --add --command docker b build
abbr --add --command docker l logs
abbr --add --command docker lf 'logs -f'
abbr --add --set-cursor=% --command docker eb 'exec -it % /bin/bash'
abbr --add --set-cursor=% --command docker esh 'exec -it % /bin/sh'
abbr --add --command 'docker compose' u up
abbr --add --command 'docker compose' ud 'up -d'
abbr --add --command 'docker compose' d down
abbr --add --command 'docker compose' r restart
abbr --add --command 'docker compose' b build
abbr --add --command 'docker compose' ps ps
abbr --add --command 'docker compose' l logs
abbr --add --command 'docker compose' lf 'logs -f'
abbr --add --command docker st start
abbr --add --command docker sto stop
abbr --add --command docker rs restart
abbr --add --command docker in inspect
abbr --add --command docker v volume

# gh (GitHub CLI)
abbr --add --command gh prc 'pr create'
abbr --add --command gh prv 'pr view'
abbr --add --command gh prl 'pr list'
abbr --add --command gh prm 'pr merge'
abbr --add --command gh prch 'pr checkout'
abbr --add --command gh prd 'pr diff'
abbr --add --command gh isc 'issue create'
abbr --add --command gh isv 'issue view'
abbr --add --command gh isl 'issue list'
abbr --add --command gh rv 'repo view'

# glab (GitLab CLI)
abbr --add --command glab mrc 'mr create'
abbr --add --command glab mrv 'mr view'
abbr --add --command glab mrl 'mr list'
abbr --add --command glab mrm 'mr merge'
abbr --add --command glab mrch 'mr checkout'
abbr --add --command glab isc 'issue create'
abbr --add --command glab isv 'issue view'
abbr --add --command glab isl 'issue list'

# tmux
abbr -a ta tmux new-session -A -s main
abbr -a tlh tmux select-layout even-horizontal
abbr -a tlv tmux select-layout even-vertical

# ghq / gwq / fzf
abbr -a gg ghq get -p
abbr -a fr 'pushd (ghq list -p | fzf --reverse --exit-0)'
abbr -a fw 'pushd (gwq list -p | fzf --reverse --exit-0)'
abbr -a fn 'find . -type f -not -path "**/node_modules/*" -not -path "**/.git/*" -not -path "**/.docker/*" | fzf --reverse --exit-0 | xargs -r nvim'

# clipboard / functions ----------------------------------------
# OSC52でホスト側(Windows Terminal)のクリップボードへ送る
function __clip
    set -l input
    if test (count $argv) -gt 0
        set input (string join \n $argv)
    else
        set input (cat)
    end
    printf '\e]52;c;%s\a' (printf '%s' $input | base64 -w0)
end

function cpb
    set -l b (git rev-parse --abbrev-ref HEAD 2>/dev/null)
    test -z "$b"; and return
    printf '%s' $b | __clip
    echo "Copied: $b"
end

function cph
    set -l h (git rev-parse --short HEAD 2>/dev/null)
    test -z "$h"; and return
    printf '%s' $h | __clip
    echo "Copied: $h"
end

function cpr
    set -l r (git remote get-url origin 2>/dev/null)
    test -z "$r"; and return
    printf '%s' $r | __clip
    echo "Copied: $r"
end

function cpd
    printf '%s' (pwd) | __clip
    echo "Copied: "(pwd)
end

function greprep
    argparse 'e/exclude-dir=+' -- $argv
    or return

    if test (count $argv) -ne 2
        echo 引数が2つじゃないよ
        echo "Usage: greprep [-e/--exclude-dir DIR]... BEFORE AFTER"
        return
    end

    set -l exclude_dirs node_modules .next .venv __pycache__ .pytest .pytest_cache htmlcov .ruff_cache .git debug dist
    if set -q _flag_exclude_dir
        set -a exclude_dirs $_flag_exclude_dir
    end

    set -l grep_excludes
    for d in $exclude_dirs
        set -a grep_excludes "--exclude-dir=$d"
    end

    set -l find_excludes
    for d in $exclude_dirs
        set -a find_excludes -not -path "*/$d/*"
    end

    echo ファイル中身置換 --------------
    grep -rl $argv[1] $grep_excludes --exclude="*.log"
    echo 上記の $argv[1] を $argv[2] へ置換します
    echo "実行しますか?(y/N): " ; read ans ; if test "$ans" != "y" ; echo 中止しました ; return ; else ; echo 実行します
        grep -rl $argv[1] $grep_excludes --exclude="*.log" | xargs sed -i "s/$argv[1]/$argv[2]/g"
    end
    echo

    echo ファイル名置換 ------------------
    find . $find_excludes -name "*$argv[1]*" | sed -E "p;s/$argv[1]/$argv[2]/" | xargs -n2 echo
    echo 上記を置換します
    echo "実行しますか?(y/N): " ; read ans ; if test "$ans" != "y" ; echo 中止しました ; return ; else ; echo 実行します
        find . $find_excludes -name "*$argv[1]*" | sed -E "p;s/$argv[1]/$argv[2]/" | xargs -n2 mv
    end
    echo
end

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

function nyaf
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
