let mapleader = "\<Space>"

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins
Plugin 'VundleVim/Vundle.vim'

" nice bar below
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Theme
Plugin 'ayu-theme/ayu-vim'

" Completer
Plugin 'Valloric/YouCompleteMe'

" change to repo root when searching
Plugin 'airblade/vim-rooter'

" fzf for searching
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'

" highlighting copied stuff
Plugin 'machakann/vim-highlightedyank'

" directory tree
Plugin 'scrooloose/nerdtree'

" syntax highlighting
Plugin 'sheerun/vim-polyglot'

" tags management
Plugin 'ludovicchabant/vim-gutentags'

" asynchronous linter
Plugin 'dense-analysis/ale'

" clang-format integration
Plugin 'rhysd/vim-clang-format'

" fswitch to change between header and source files
Plugin 'derekwyatt/vim-fswitch'

" git plugins
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

call vundle#end()            " required
filetype plugin indent on    " required

""""""""""""""""""""""""""""""""""""""""""""" airline config
if !exists('g:airline_symbols')
      let g:airline_symbols = {}
    endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
"
" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" theme
let g:airline_theme='onehalfdark'


""""""""""""""""""""""""""""""""""""""""""""" ale config 
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'javascriptreact': ['eslint'],
\}

let g:ale_linters_explicit = 1


""""""""""""""""""""""""""""""""""""""""""""" ycm config 
" blacklist c/cpp files:
"let g:ycm_filetype_blacklist = {'c': 1, 'h': 1, 'cpp': 1}
" disabling preview window:
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_show_diagnostics_ui = 1
set completeopt-=preview

" clang_complete stuff:
let g:clang_library_path='/usr/lib/llvm-3.8/lib/'


""""""""""""""""""""""""""""""""""""""""""""" tags config
set tags=./tags;,tags;
let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]


""""""""""""""""""""""""""""""""""""""""""""" history config
" history vim remembers
set history=500
filetype plugin indent on


""""""""""""""""""""""""""""""""""""""""""""" tabs/spaces config
" show existing tab with 4 spaces width
" when indenting with '>', use 4 spaces width
set tabstop=4
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab


""""""""""""""""""""""""""""""""""""""""""""" ayu config (color theme)
colorscheme ayu
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
let g:airline_theme='ayu'
let ayucolor="mirage"

syntax on
set background=dark


""""""""""""""""""""""""""""""""""""""""""""" mouse and keyboard
"enable mouse usage
set mouse=a

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

" normal tab usage for autocomplete:
"inoremap <expr><Tab> (pumvisible()?(empty(v:completed_item)?"\<C-n>":"\<C-y>"):"\<Tab>")
"inoremap <expr><CR> (pumvisible()?(empty(v:completed_item)?"\<CR>\<CR>":"\<C-y>"):"\<CR>")

" fzf hotkeys:
map <C-k> :Files<CR>
nmap <leader>; :Buffers<CR>

" paste mode on F2
set pastetoggle=<F2>

" resizing of split windows
nnoremap <C-H> :vertical resize -2<CR>
nnoremap <C-L> :vertical resize +2<CR>

" always ask where to jump
nnoremap <C-]> g<C-]>

" FSwitch shortcut
nmap <leader>[ :FSHere<CR>


""""""""""""""""""""""""""""""""""""""""""""" line numbers
"enable line number
set number
set relativenumber


""""""""""""""""""""""""""""""""""""""""""""" fzf config
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


""""""""""""""""""""""""""""""""""""""""""""" no idea
set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendo

" TO REMOVE when I will get newer vim or nvim
if !exists('##TextYankPost')
      map y <Plug>(highlightedyank)
endif


""""""""""""""""""""""""""""""""""""""""""""" undo history
set undodir=~/.vim/undo
set undofile


""""""""""""""""""""""""""""""""""""""""""""" NERDTree config
" nerdtree open
nnoremap <C-n> :NERDTreeToggle %<CR>

let g:NERDTreeWinSize=50


""""""""""""""""""""""""""""""""""""""""""""" clang-format config
let g:clang_format#detect_style_file=1
let g:clang_format#auto_format=1
