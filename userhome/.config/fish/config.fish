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


# function unko
	# set ifs
	# set all_nvim_proc (ps -efl | grep [n]vim) # セッション問わず起動中のnvimプロセス全て
	# set ifs \n" "\t
	
	# echo $all_nvim_proc
	# for pane_start_pid in (string split ' ' (echo (tmux list-panes -F "#{pane_pid}")))
		# echo $pane_start_pid
		# # if contains $pane_start_pid (echo $all_nvim_proc | awk '{print $5}')
		# if (echo $all_nvim_proc | awk -v psp=$pane_start_pid '$5 == psp && $2 == S')
			# echo このウインドウ内にnvimが存在し、それはフォアグラウンドです
		# else if (echo $all_nvim_proc | awk -v psp=$pane_start_pid '$5==psp && $2==T')
			# echo このウインドウ内にnvimが存在し、それはバックグラウンドです
		# else
			# echo なんもひっかからんかった, $status
		# end
	# end
# end

