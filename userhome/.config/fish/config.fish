set -g theme_color_scheme base16-light

export EDITOR="/usr/bin/nvim"

abbr -a e explorer.exe
abbr -a vi nvim

abbr -a cdd cd /mnt/d/win/denon
# abbr -a yp youtube-dl --download-archive ./downloaded.txt

function mkmainpy
	# 直下のディレクトリにmain.pyとinput.txtを作る
	for dir in (find ./ -maxdepth 1 -mindepth 1 -type d)
		touch $dir/input.txt
		if not test -e $dir/main.py
			touch $dir/main.py
		end
	end
	# vscodeの統合ターミナルから実行する場合はvscodeで開く
	if test "$TERM_PROGRAM" = "vscode"
		for mainpy in (find ./ -name main.py | sort)
			code $mainpy
		end
	end
end
