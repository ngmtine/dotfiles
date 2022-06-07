# set -g theme_color_scheme base16-light
set -g theme_display_docker_machine yes
set -g theme_display_virtualenv yes
set -g theme_nerd_fonts yes
set -g theme_title_use_abbreviated_path no
set -g theme_newline_cursor yes
set -g theme_newline_prompt '$ '
# masterでもブランチ名を表示
set -g theme_display_git_master_branch yes
# コマンドの実行時間を表示
set -g theme_display_cmd_duration yes
# exitステータスを表示
set -g theme_show_exit_status yes
# ディレクトリ名を省略しない
set -g fish_prompt_pwd_dir_length 0

export EDITOR="/usr/bin/nvim"

abbr -a e explorer.exe
abbr -a vi nvim
abbr -a yank win32yank.exe
abbr -a ff '"/mnt/c/Program Files/Mozilla Firefox/firefox.exe"'
abbr -a ydl youtube-dl -f bestvideo+bestaudio --merge-output-format mp4

# gitのエイリアス
# ~/.gitconfig を編集する手もあるけど、fishと違い実行時に展開されない（エイリアスなので当たり前だけど）
abbr -a g git
abbr -a gad git add
abbr -a gcm git commit -m \" # "
abbr -a gps git push
abbr -a gpl git pull
abbr -a gcl git clone
abbr -a gck git checkout
abbr -a gbr git branch -a
abbr -a gst git status
abbr -a gfe git fetch

# dockerのエイリアス
abbr -a d docker
abbr -a dps docker container ls
abbr -a dls docker container ls
abbr -a dcp docker container cp
abbr -a dex docker container exec
# abbr -a dc docker container
# abbr -a di docker image

abbr -a cdd cd /mnt/d/win/denon
# abbr -a yp youtube-dl --download-archive ./downloaded.txt

function mkmainpy
if test "$TERM_PROGRAM" = "vscode"
		for dir in (find ./ -maxdepth 1 -mindepth 1 -type d)
			if not test -e $dir/main.py
				touch $dir/main.py
			end
			if not test -e $dir/input.txt
				touch $dir/input.txt
			end
		end
	for mainpy in (find ./ -name main.py | sort)
		code $mainpy
	end	
	else
		echo "vscode上で実行してね～"
	end
end

function gitsimplesync
	set _pwd (basename @(pwd))
	if test $_pwd = "memo"
		git pull && git add . && git commit -m "push with gitsimplesync" && git push
	else
		echo 所定のフォルダでのみ実行してね！
	end
end
abbr -a gss gitsimplesync

if test -f $__fish_config_dir/config_indiv.fish
	source $__fish_config_dir/config_indiv.fish
end

# ghq
abbr -a gg ghq get -p
abbr -a gl ghq list --full-path

# peco
abbr -a p peco

# plugin-peco
# https://github.com/oh-my-fish/plugin-peco
function fish_user_key_bindings
	bind \cr 'peco_select_history (commandline -b)'
end

# color setting
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

# color settings -------------------------------------
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


bobthefish_colors
