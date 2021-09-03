set -g theme_color_scheme base16-light

export EDITOR="/usr/bin/nvim"

abbr -a e explorer.exe
abbr -a vi nvim

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
		git pull && git add . && git commit -m "a" && git push
	else
		echo 所定のフォルダでのみ実行してね！
	end
end
