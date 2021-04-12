set -g theme_color_scheme base16-light

export EDITOR="/usr/bin/nvim"

abbr -a e explorer.exe
abbr -a vi nvim

function nvim -d "tmuxの同一ウインドウ内にnvimが起動済みならばそちらで開きます"
	if test -z $TMUX
		# tmuxの外ならば、そのままnvimを起動する
		command nvim $argv
	else
		set socket_path /tmp/(echo (tmux display-message -p -F "#{session_id}#{window_index}nvim"))
		if test -S $socket_path
			# 既にnvim起動中ならば
			set IFS
			set all_nvim_proc (ps -efl | grep [n]vim) # セッション問わず起動中のnvimプロセス全て
			set IFS \n" "\t
			for pane_start_pid in (string split ' ' (echo (tmux list-panes -F "#{pane_pid}")))
				# このウィンドウ内に存在する、全てのペインの起動時pidを列挙
				if test (echo $all_nvim_proc | awk -v psp=$pane_start_pid '{if ($5==psp && $2=="S") print 0}') = 0
					# このウインドウ内にフォアグラウンドのnvimが存在する
					nvr --remote-tab --servername $socket_path $argv
				else if test (echo $all_nvim_proc | awk -v psp=$pane_start_pid '{if ($5==psp && $2=="T") print 0}') = 0
					# このウインドウ内にバックグラウンドのnvimが存在する
					echo フォアグラウンドにもってきてnvrする
				else
					echo statがSとT以外です
				end
			end
		else
			command env NVIM_LISTEN_ADDRESS=$socket_path nvim $argv
		end
	end
end

abbr -a cdd cd /mnt/d/win/denon
# abbr -a yp youtube-dl --download-archive ./downloaded.txt

