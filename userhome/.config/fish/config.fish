set -g theme_color_scheme base16-light

export EDITOR="/usr/bin/nvim"

abbr -a e explorer.exe
abbr -a vi nvim

function nvim -d "tmuxの同一ウインドウ内にnvimが起動済みならばそちらで開きます"
	if test -z $TMUX
		command nvim $argv
	else
		set socket_path /tmp/(echo (tmux display-message -p -F "#{session_id}#{window_index}nvim"))
		if test -S $socket_path
			nvr --remote-tab --servername $socket_path $argv
		else
			command env NVIM_LISTEN_ADDRESS=$socket_path nvim $argv
		end
	end
end

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