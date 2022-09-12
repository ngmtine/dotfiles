" 基本設定 -------------------------------------------------
set mouse=a " マウス有効化
" set timeoutlen=1000 ttimeoutlen=0 " escで抜けたときにワンテンポ遅れる問題の対応、数字によってはmap <C-w>/ みたいな複数入力の受付に影響するっぽい

" UI
set number " 行番号表示
set showtabline=2 " タブ常に表示
syntax on " シンタックスハイライト
set list listchars=tab:\▸\-,eol:↲,trail:_

" ファイル/バッファの扱い
set encoding=utf-8
scriptencoding utf-8
set fileencodings=utf-8,cp932
set autoread " 外部でファイルに変更がされた場合は読みなおす
set noswapfile " スワップファイル作成しない
set hidden " バッファ切替時に保存してないぞっていちいち言ってこなくなる
" autocmd BufRead * tab ball " 開いているバッファをすべてタブ化する、但し何故かカラースキームが無効化する

" アンドゥ履歴の永続化
augroup SaveUndoFile
	set undodir=~/.config/nvim/undo
	set undofile
augroup END

" カーソルの挙動
" カーソル位置そのままでインサート抜ける
" autocmd InsertLeave * :normal! `^
" set whichwrap=b,s,h,l,<,>,[,],~ " 行またいで移動
" set virtualedit=onemore " 行またいで移動

" インデント関係
set noexpandtab " tabの入力をスペースに置き換えない
set tabstop=4 " tabの入力による見た目のスペース数
set shiftwidth=4 " インデントの見た目のスペース数
set softtabstop=0 " tabの入力による見た目のスペース数、0でtabstopの値と同じ
set smarttab " 行頭tab入力でインデントを挿入

" 検索
set hlsearch " 検索結果ハイライト
set incsearch " インクリメンタルサーチ
set smartcase " 小文字で検索開始した際に大文字小文字無視

" 折りたたみ
set foldmethod=indent " 折りたたみをインデント単位で行う
set foldlevel=100 " ファイルオープン時に折りたたまない

" ファイルタイプ
autocmd BufEnter *.fish set filetype=sh

" キーバインド ----------------------------------------
inoremap <C-j> <Esc><Right>
inoremap <Esc> <Esc><Right>
nnoremap H ^
vnoremap H ^
nnoremap L $
vnoremap L $
nnoremap Y y$
nnoremap < <<
vnoremap < <gv
nnoremap > >>
vnoremap > >gv
" nnoremap <C-a> ggVG " 全選択、c-oを2連で元位置に戻る
nnoremap x "_x
nnoremap U <C-r>
nnoremap <silent> p p`]
vnoremap <silent> p p`]
" nnoremap q <Nop> " マクロ封印
nnoremap Q <Nop> " exモード封印
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l> " ハイライト消去
" 後方検索
nnoremap \ ?

nnoremap j gj
nnoremap k gk

" w/bの単語移動の際記号は無視、vscodeでは無理そう
" nnoremap <silent> w :call search('\<\w', 'W')<cr>
" nnoremap <silent> b :call search('\<\w', 'bW')<cr>

" emacs-likeキーバインド
inoremap <C-a> <Esc>^i
inoremap <C-e> <Esc>$i<Right>
inoremap <C-k> <Esc><Right>d$i " ちなみにc-uはvimもデフォで前方削除
 
" コマンドラインのキーバインド
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <expr> <Up> pumvisible() ? "<C-p>" : "<Up>"
cnoremap <expr> <Down> pumvisible() ? "<C-n>" : "<Down>"

" 参考：https://stackoverflow.com/questions/18948491/running-python-code-in-vim
" 編集中のファイルを実行
" autocmd FileType python map <buffer> <F5> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
" autocmd FileType python imap <buffer> <F5> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

" タブとウィンドウのキーバインド
nnoremap <C-w>/ :rightbelow vnew<CR>
nnoremap <C-w>- :rightbelow new<CR>
nnoremap <C-w>\ :rightbelow new<CR>
nnoremap <tab> gt
nnoremap <S-tab> gT

" アンドゥの粒度小さく（spaceで区切る）
inoremap <Space> <Space><C-g>u

" リーダーキー ----------------------------------------
" let mapleader = "\<Space>"
" set pastetoggle=<leader>p " ペーストモードトグル
" nnoremap <leader>r :source $MYVIMRC<CR> " init.vimのリロード、ただしairlineが再描画されない？tmuxでウインドウ切り替えれば再描画されるっぽい

" プラグイン ------------------------------------------
packadd vim-jetpack
call jetpack#begin()
	" bootstrap
	Jetpack 'tani/vim-jetpack', {'opt': 1}
	" UI
	Jetpack 'cocopon/iceberg.vim'
	Jetpack 'vim-airline/vim-airline'
	Jetpack 'edkolev/tmuxline.vim'
	Jetpack 'airblade/vim-gitgutter'
	" エディタ
	Jetpack 'tpope/vim-surround'
	Jetpack 'preservim/nerdcommenter'
	Jetpack 'ojroques/vim-oscyank'
	Jetpack 'rhysd/clever-f.vim'
	Jetpack 'norcalli/nvim-colorizer.lua'
	Jetpack 'lambdalisue/suda.vim'
	Jetpack 'christoomey/vim-tmux-navigator'
	Jetpack 'luukvbaal/nnn.nvim'
	" LSP
	Jetpack 'neoclide/coc.nvim', {'branch': 'release'}
call jetpack#end()

" カラースキーム --------------------------------------
set termguicolors " truecolor
colorscheme iceberg

" vim-airline -----------------------------------------
let g:airline_theme = 'iceberg'
let g:airline_powerline_fonts = 1

" nerd commenter ----------------------------------
let g:NERDCreateDefaultMappings=0
let g:NERDSpaceDelims=1

" <C-/>にコメントアウトのトグルを当てる
" スラッシュのキー指定はosによって異なり、windowsだとスラッシュの代わりにアンダーバーで指定できるらしい
" 参考：https://stackoverflow.com/questions/9051837/how-to-map-c-to-toggle-comments-in-vim
nmap <C-_> <Plug>NERDCommenterToggle
vmap <C-_> <Plug>NERDCommenterToggle

" クリップボード（oscyank） ---------------------------------
if exists('g:vscode')
	" wslにwin32yank.exeが必要
	autocmd TextYankPost * call system('win32yank.exe -i --crlf', @")
	function! Paste(mode)
		let @" = system('win32yank.exe -o --lf')
		return a:mode
	endfunction
	map <expr> p Paste('p')
	map <expr> P Paste('P')
endif
if !exists('g:vscode')
    " set clipboard+=unnamedplus
	let g:oscyank_term = 'tmux'
	autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif
endif

" norcalli/nvim-colorizer.lua 色見本 ---------------------------------
lua require'colorizer'.setup()

" vim-tmux-navigator ------------------------------
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
let g:tmux_navigator_save_on_switch = 2

" coc
let g:coc_node_path = '/home/nag/.anyenv/envs/nodenv/shims/node'
set statusline^=%{coc#status()}
let g:coc_global_extensions = ["coc-pyright", "coc-json", "coc-html", "coc-css", "coc-tsserver"]

" nnn.nvim
lua << EOF
require("nnn").setup()
EOF

if !exists('g:vscode')

	" 以下はcocの機能だがvscodeで読み込むと正常に動作しなくなる
	" 補完の挙動
	set completeopt=menu,menuone,noinsert,noselect
	" 補完表示時のenterで改行しない (<Down>と<C-n>には挙動に違いがあり、前者は候補選択即挿入だが後者は選択のみ)
	inoremap <expr> <CR> coc#pum#visible() ? "<C-y>" : "<CR>"
	cnoremap <expr> <CR> wildmenumode() ? "<C-y>" : "<CR>"
	inoremap <expr> <Tab> coc#pum#visible() ? "<C-n>" : "<Tab>"
	inoremap <expr> <Down> coc#pum#visible() ? "<C-n>" : "<Down>"
	inoremap <expr> <S-Tab> coc#pum#visible() ? "<C-p>" : "<S-Tab>"
	inoremap <expr> <Up> coc#pum#visible() ? "<C-p>" : "<Up>"
	" " 補完取り消す時に元の入力内容に戻す
	" inoremap <expr> <Esc> coc#pum#visible() ? "\<c-e>" : "<Esc>"
	cnoremap <expr> <Esc> wildmenumode() ? "\<c-e>" : "<Esc>"

	" カーソル位置の保持
	augroup KeepLastPosition
		au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
	augroup END

endif

" 保存時にディレクトリが無ければ作る
augroup vimrc-auto-mkdir
	autocmd!
	autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
	function! s:auto_mkdir(dir, force)
		if !isdirectory(a:dir) && (a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
		  call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
		endif
	endfunction
augroup END
