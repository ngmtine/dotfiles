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
