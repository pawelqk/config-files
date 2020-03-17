let mapleader = "\<Space>"

" YCM stuff:
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

"theme plugins
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'dracula/vim'

Plugin 'Valloric/YouCompleteMe'

Plugin 'airblade/vim-rooter'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'

Plugin 'machakann/vim-highlightedyank'
Plugin 'scrooloose/nerdtree'

Plugin 'sheerun/vim-polyglot'

Plugin 'ludovicchabant/vim-gutentags'

Plugin 'chriskempson/base16-vim'

Bundle 'sonph/onehalf', {'rtp': 'vim/'}
call vundle#end()            " required
filetype plugin indent on    " required

"for onehalfdark theme
let g:airline_theme='onehalfdark'

" theme contrast

" YCM stuff:
" blacklist c/cpp files:
"let g:ycm_filetype_blacklist = {'c': 1, 'h': 1, 'cpp': 1}
" disabling preview window:
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_show_diagnostics_ui = 1
set completeopt-=preview

" clang_complete stuff:
let g:clang_library_path='/usr/lib/llvm-3.8/lib/'

" adding tags to project
set tags=./tags;,tags;

" history vim remembers
set history=500
filetype plugin indent on
" show existing tab with 4 spaces width
" when indenting with '>', use 4 spaces width
set tabstop=4
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" enable syntax color
syntax enable
colorscheme base16-atelier-dune
set termguicolors

" not yet done
set background=dark

"enable mouse usage
set mouse=a

"enable line number
set number
set relativenumber

" disable arrows
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" mappings:
map <c-\> :vsplit<Enter>
inoremap <A-Left> <c-o>
inoremap <A-Right> <c-i>

" normal tab usage for autocomplete: TODO:
"inoremap <expr><Tab> (pumvisible()?(empty(v:completed_item)?"\<C-n>":"\<C-y>"):"\<Tab>")
"inoremap <expr><CR> (pumvisible()?(empty(v:completed_item)?"\<CR>\<CR>":"\<C-y>"):"\<CR>")

" fzf hotkeys:
map <C-k> :Files<CR>
nmap <leader>; :Buffers<CR>

" fzf config:
let g:fzf_layout = { 'down': '~20%' }
let $FZF_DEFAULT_COMMAND = 'rg --files' " using ripgrep
noremap <leader>s :Rg<CR>
if executable('rg')
    set grepprg=rg\ --no-heading\ --vimgrep
endif
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   "rg --column --line-number --no-heading --color=always ".shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \ <bang>0)
"switching between buffered files
nnoremap <leader><leader> <c-^>


" no idea:
set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendo


set undodir=~/.vim/undo
set undofile

nnoremap <C-H> :vertical resize -2<CR>
nnoremap <C-L> :vertical resize +2<CR>

" nerdtree open
nnoremap <C-n> :NERDTreeToggle<CR>

let g:NERDTreeWinSize=50

" TO REMOVE when I will get newer vim or nvim (this won't happen xD)\
if !exists('##TextYankPost')
      map y <Plug>(highlightedyank)
endif

" paste mode on F2
set pastetoggle=<F2>

