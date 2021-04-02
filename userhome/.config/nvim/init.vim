" 基本設定 --------------------------------------------
set encoding=utf-8
scriptencoding utf-8
set fileencodings=utf-8,cp932
" set mouse=a
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
set tabstop=4
set shiftwidth=4
" set foldmethod=indent

" カーソル位置の保持
augroup KeepLastPosition
	au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
augroup END

" アンドゥ履歴の永続化
augroup SaveUndoFile
	set undodir=~/.config/nvim/undo
	set undofile
augroup END

" キーバインド ----------------------------------------
inoremap <C-j> <esc><Right>
nnoremap <C-j> <esc><Right>
vnoremap <C-j> <esc><Right>
inoremap <Esc> <Esc><Right>
nnoremap j gj
nnoremap k gk
nnoremap J }
nnoremap K {
nnoremap H ^
nnoremap L $
nnoremap Y y$
vnoremap < <gv
nnoremap < <<
vnoremap > >gv
nnoremap > >>
nnoremap x "_x

" w/bの単語移動の際記号は無視、vscodeでは無理そう
" nnoremap <silent> w :call search('\<\w', 'W')<cr>
" nnoremap <silent> b :call search('\<\w', 'bW')<cr>

" eacs-likeキーバインド
inoremap <C-a> <Esc>^i
inoremap <C-e> <Esc>$i<Right>

" windows-likeキーバインド
nnoremap <C-a> ggVG
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>

" 編集中のファイルを実行
" 参考：https://stackoverflow.com/questions/18948491/running-python-code-in-vim
autocmd FileType python map <buffer> <F5> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F5> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

" nnoremap <C-w>- 

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
Plug 'ojroques/vim-oscyank'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'
" Plug 'ryanoasis/vim-devicons'
" Plug 'tpope/vim-surround'
" Plug 'mg979/vim-visual-multi'
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
let g:coc_global_extensions = ['coc-pairs']

" set completeopt=menuone "補完候補1つでも表示する
" 三項演算子
" a の評価結果が1(true)ならb、0(false)ならc
" a ? b : c"
" 補完候補表示時での<Down>と<C-n>には挙動に違いがあり、前者は候補選択即挿入だが後者は選択のみ
inoremap <expr> <Tab> pumvisible() ? "<C-n>" : "<Tab>"
inoremap <expr> <Down> pumvisible() ? "<C-n>" : "<Down>"
inoremap <expr> <S-Tab> pumvisible() ? "<C-p>" : "<S-Tab>"
inoremap <expr> <Up> pumvisible() ? "<C-p>" : "<Up>"
" 補完取り消す時に元の入力内容に戻す
inoremap <expr> <Esc>umvisible() ? "\<c-e>" : "<Esc>"

" vim-oscyank --------------------------------------
set clipboard+=unnamedplus

augroup OSCYank
	autocmd!
	autocmd TextYankPost * :call YankOSC52(getreg('+'))
augroup END

" vim-tmux-navigator ------------------------------
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
let g:tmux_navigator_save_on_switch = 2
