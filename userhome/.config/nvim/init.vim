" 基本設定 -------------------------------------------------
set clipboard+=unnamedplus " クリップボード共有
set noexpandtab " tabの入力をスペースに置き換えない
set encoding=utf-8
scriptencoding utf-8
set fileencodings=utf-8,cp932
set mouse=a
set number
set hlsearch
set incsearch
set smartcase
syntax on
set whichwrap=b,s,h,l,<,>,[,],~
set noswapfile
set virtualedit=onemore
set hidden
set autoread
set foldmethod=indent " 折りたたみをインデント単位で行う
set foldlevel=100 " ファイルオープン時に折りたたまない
set tabstop=4 " tabの入力による見た目のスペース数
set shiftwidth=4 " インデントの見た目のスペース数
set softtabstop=0 " tabの入力による見た目のスペース数、0でtabstopの値と同じ
set smarttab
set list listchars=tab:\▸\-,eol:↲,trail:_
set timeoutlen=1000 ttimeoutlen=0 " escで抜けたときにワンテンポ遅れる問題の対応、数字によってはmap <C-w>/ みたいな複数入力の受付に影響するっぽい
set showtabline=2 " タブ常に表示
set hidden " バッファ切替時に保存してないぞっていちいち言ってこなくなる
" autocmd BufRead * tab ball " 開いているバッファをすべてタブ化する、但し何故かカラースキームが無効化する

" カーソル位置の保持
augroup KeepLastPosition
	au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
augroup END

" アンドゥ履歴の永続化
augroup SaveUndoFile
	set undodir=~/.config/nvim/undo
	set undofile
augroup END

" .fishを.shと同様に扱う
autocmd BufEnter *.fish set filetype=sh

" escで抜けたときにカーソルを右に移動
au InsertLeave * call cursor([getpos('.')[1], getpos('.')[2]+1])

" キーバインド ----------------------------------------
nnoremap H ^
vnoremap H ^
nnoremap L $
vnoremap L $
nnoremap J }
vnoremap J }
nnoremap K {
vnoremap K {
nnoremap Y y$
nnoremap < <<
vnoremap < <gv
nnoremap > >>
vnoremap > >gv
nnoremap <C-a> ggVG
nnoremap x "_x
nnoremap U <C-r>
nnoremap <silent> p p`]
vnoremap <silent> p p`]
nnoremap q <Nop> " マクロ封印
nnoremap Q <Nop> " exモード封印
nnoremap <Tab> % " 対応ペアに移動
vnoremap <Tab> % " 対応ペアに移動
nnoremap <silent> <Esc><Esc> :noh<CR> " esc2連でハイライト削除

nnoremap j gj
nnoremap k gk
inoremap <C-v> <Esc>pa

" 行を移動（なんか動かん）
nnoremap <C-Up> "zdd<Up>"zP
nnoremap <C-Down> "zdd"zp
vnoremap <C-Up> "zx<Up>"zP`[V`]
vnoremap <C-Down> "zx"zp`[V`]

" w/bの単語移動の際記号は無視、vscodeでは無理そう
" nnoremap <silent> w :call search('\<\w', 'W')<cr>
" nnoremap <silent> b :call search('\<\w', 'bW')<cr>

" emacs-likeキーバインド
inoremap <C-a> <Esc>^i
inoremap <C-e> <Esc>$i<Right>
inoremap <C-k> <Esc><Right>d$i

" windows-likeキーバインド
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>

" コマンドラインのキーバインド
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <expr> <Up> pumvisible() ? "<C-p>" : "<Up>"
cnoremap <expr> <Down> pumvisible() ? "<C-n>" : "<Down>"

" 参考：https://stackoverflow.com/questions/18948491/running-python-code-in-vim
" 編集中のファイルを実行
autocmd FileType python map <buffer> <F5> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F5> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

" タブとウィンドウのキーバインド
nnoremap <C-w>/ :rightbelow vnew<CR>
nnoremap <C-w>- :rightbelow new<CR>
nnoremap <C-w>\ :rightbelow new<CR>
nnoremap <tab> gt
nnoremap <S-tab> gT

" 補完の挙動
set completeopt=menu,menuone,noinsert,noselect
" 三項演算子
" 評価 ? true : false
" 補完表示時のenterで改行しない (<Down>と<C-n>には挙動に違いがあり、前者は候補選択即挿入だが後者は選択のみ)
inoremap <expr> <CR>  pumvisible() ? "<C-y>" : "<CR>"
cnoremap <expr> <CR>  wildmenumode() ? "<C-y>" : "<CR>"
inoremap <expr> <Tab> pumvisible() ? "<C-n>" : "<Tab>"
inoremap <expr> <Down> pumvisible() ? "<C-n>" : "<Down>"
inoremap <expr> <S-Tab> pumvisible() ? "<C-p>" : "<S-Tab>"
inoremap <expr> <Up> pumvisible() ? "<C-p>" : "<Up>"
" " 補完取り消す時に元の入力内容に戻す
inoremap <expr> <Esc> pumvisible() ? "\<c-e>" : "<Esc>"
cnoremap <expr> <Esc> wildmenumode() ? "\<c-e>" : "<Esc>"

" リーダーキー ----------------------------------------
" let mapleader = "\<Space>" # この書き方だとターミナルの機能でペーストする時、貼り付け文字列に空白が含まれてるとリーダーキーが発動してしまうことに注意

set pastetoggle=<leader>p " ペーストモードトグル
" nnoremap <leader>r :source $MYVIMRC<CR> " init.vimのリロード、ただしairlineが再描画されない？tmuxでウインドウ切り替えれば再描画されるっぽい

" プラグイン ------------------------------------------
call plug#begin('~/.config/nvim/autoload')
Plug 'cocopon/iceberg.vim'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdcommenter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
" Plug 'ryanoasis/vim-devicons'
Plug 'puremourning/vimspector'
Plug 'jacquesbh/vim-showmarks'
Plug 'ojroques/vim-oscyank'
Plug 'lambdalisue/suda.vim'
Plug 'mindriot101/vim-yapf'
call plug#end()

" カラースキーム --------------------------------------
set termguicolors " truecolor
colorscheme iceberg

" シェルの環境変数$backgroundによってライトテーマとダークモードの切り替えを行う
" .bashrc などで export background=light 記述しておく
" ターミナルのカラースキームに合わせてカラーコードをハードコーディングしているため、テーマを変更するたびに編集する必要あり
if $background == "light"
	set background=light
	let g:ActiveBackGround = 'guibg=#fafafa'
	let g:InactiveBackGround = 'guibg=#e0e0e0'
	hi Normal guibg=.g:ActiveBackGround " この行無いとtmux外からnvim起動したときに背景色適用されない
	augroup ChangeBackGround
		autocmd!
		autocmd FocusGained * execute('hi Normal '.g:ActiveBackGround)
		autocmd FocusGained * execute('hi NonText '.g:ActiveBackGround)
		autocmd FocusGained * execute('hi SpecialKey '.g:ActiveBackGround)
		autocmd FocusGained * hi EndOfBuffer ctermbg=none
		autocmd FocusLost * execute('hi Normal '.g:InactiveBackGround)
		autocmd FocusLost * execute('hi NonText '.g:InactiveBackGround)
		autocmd FocusLost * execute('hi SpecialKey '.g:InactiveBackGround)
		autocmd FocusLost * execute('hi EndOfBuffer '.g:InactiveBackGround)
	augroup end
elseif $background == "dark"
	set background=dark
	let g:ActiveBackGround = 'guibg=#161821'
	let g:InactiveBackGround = 'guibg=#262831'
	hi Normal guibg=.g:ActiveBackGround " この行無いとtmux外からnvim起動したときに背景色適用されない
	augroup ChangeBackGround
		autocmd!
		autocmd FocusGained * execute('hi Normal '.g:ActiveBackGround)
		autocmd FocusGained * execute('hi NonText '.g:ActiveBackGround)
		autocmd FocusGained * execute('hi SpecialKey '.g:ActiveBackGround)
		autocmd FocusGained * hi EndOfBuffer ctermbg=none
		autocmd FocusLost * execute('hi Normal '.g:InactiveBackGround)
		autocmd FocusLost * execute('hi NonText '.g:InactiveBackGround)
		autocmd FocusLost * execute('hi SpecialKey '.g:InactiveBackGround)
		autocmd FocusLost * execute('hi EndOfBuffer '.g:InactiveBackGround)
	augroup end
endif

" vim-airline -----------------------------------------
let g:airline_theme = 'iceberg'
let g:airline_powerline_fonts = 1

" tmuxline.vim ----------------------------------------
" tmux内でnvimを起動した時点でtmuxline.vimが適用される
" その状態で:TmuxlineSnapshot {file} を実行するとファイルが生成される
" そのファイルを.tmux.confでsource-file {file} すればおｋ
" https://github.com/edkolev/tmuxline.vim

" netrw -----------------------------------------------
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25

let g:NetrwIsOpen=0
function! ToggleNetrw()
	if g:NetrwIsOpen
		let i = bufnr("$")
		while (i >= 1)
			if (getbufvar(i, "&filetype") == "netrw")
				silent exe "bwipeout " . i
			endif
			let i-=1
		endwhile
		let g:NetrwIsOpen=0
	else
		let g:NetrwIsOpen=1
		silent Vex
	endif
endfunction

noremap <silent><leader>n :call ToggleNetrw()<CR>

" nerd commenter ----------------------------------
let g:NERDCreateDefaultMappings=0
let g:NERDSpaceDelims=1

" <C-/>にコメントアウトのトグルを当てる
" スラッシュのキー指定はosによって異なり、windowsだとスラッシュの代わりにアンダーバーで指定できるらしい
" 参考：https://stackoverflow.com/questions/9051837/how-to-map-c-to-toggle-comments-in-vim
nmap <C-_> <Plug>NERDCommenterToggle
vmap <C-_> <Plug>NERDCommenterToggle

" coc.nvim ----------------------------------------
" プロキシ環境だと503エラー出るので:CocConfingにてプロキシ記述すること
set statusline^=%{coc#status()}
let g:coc_global_extensions = ['coc-pairs', 'coc-html', 'coc-json', 'coc-yaml', 'coc-phpls', 'coc-jedi', 'coc-tsserver']

" vim-tmux-navigator ------------------------------
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
let g:tmux_navigator_save_on_switch = 2

" vim-showmarks -------------------------------------
" 但しマークを自動更新してくれない、特定のエディタコマンド実行後を示すイベントも見つからないし微妙かも
aug show-marks-sync
	au!
	au BufReadPost * sil! DoShowMarks
aug END

" vimでファイルを開いたときに、tmuxのwindow名にファイル名を表示
if exists('$TMUX') && !exists('$NORENAME')
	au BufEnter * if empty(&buftype) | call system('tmux rename-window "[vim]"'.expand('%:t:S')) | endif
	au VimLeave * call system('tmux set-window automatic-rename on')
endif

" vim-oscyank -------------------------------------------------
let g:oscyank_term = 'tmux'
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif

" インデント関係の設定がpython用のプラグインで上書きされるので、さらに上書き
augroup python_indent
	autocmd!
	autocmd FileType python setlocal noexpandtab
	autocmd FileType python setlocal tabstop=4 " tabの入力による見た目のスペース数
	autocmd FileType python setlocal shiftwidth=4 " インデントの見た目のスペース数
	autocmd FileType python setlocal softtabstop=0 " tabの入力による見た目のスペース数、0でtabstopの値と同じ
augroup END

if exists('g:vscode') " vscode -----------------------------------
	" 置換
	nnoremap <C-r> <Cmd>call VSCodeNotify('editor.action.startFindReplaceAction')<CR>
	" vnoremap <C-r> <Cmd>call VSCodeNotify('editor.action.startFindReplaceAction')<CR>

	" 畳んだコードを跨ぐ時に展開しない
	nnoremap j :call VSCodeCall('cursorDown')<CR>
	nnoremap k :call VSCodeCall('cursorUp')<CR>
endif

