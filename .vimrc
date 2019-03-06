" set default 'runtimepath' (without ~/.vim folders)
"let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
" what is the name of the directory containing this file?
"let s:portable = expand('<sfile>:p:h')
" add the directory to 'runtimepath'
"let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)

filetype off
set nocompatible " explicitly get out of vi-compatible mode
"execute pathogen#incubate()
"execute pathogen#helptags()

" Basics {

  set background=light " we plan to use a dark background
  syntax on " syntax highlighting on
  " colorscheme solarized
  filetype plugin indent on
  set modelines=5
  " Make sure that unsaved buffers that are to be put in the background are
  " allowed to go in there (ie. the "must save first" error doesn't come up)
  set hidden
  set autoindent
  set smartindent
  set backspace=indent,eol,start
  " Don't auto-insert comment leader after hitting 'o' or 'O' in Normal mode.
  autocmd FileType * setlocal formatoptions-=o
"

" Vim UI {
  set cursorline " highlight current line
  set incsearch " BUT do highlight as you type you search phrase
  set laststatus=2 " always show the status line
  set noshowmode
  set lazyredraw " do not redraw while running macros
  set linespace=0 " don't insert any extra pixel lines betweens rows
  set list " we do what to show tabs, to ensure we get them out of my files
  set listchars=tab:>-,trail:- " show tabs and trailing whitespace
  set matchtime=5 " how many tenths of a second to blink matching brackets for
  set nohlsearch " do not highlight searched for phrases
  set nostartofline " leave my cursor where it was
  set novisualbell " don't blink
  set number " turn on line numbers
  set numberwidth=5 " We are good up to 99999 lines
  set report=0 " tell us when anything is changed via :...
  set ruler " Always show current positions along the bottom
  set scrolloff=10 " Keep 5 lines (top/bottom) for scope
  set shortmess=atIoO " shortens messages to avoid 'press a key' prompt
  set showcmd " show the command being typed
  set showmatch " show matching brackets
  set sidescrolloff=10 " Keep 5 lines at the side
  let g:airline_powerline_fonts = 1
"  let g:airline#extensions#tabline#enabled = 1
  let g:terraform_align = 1
  let g:terraform_remap_spacebar=1
  let g:terraform_fmt_on_save = 1
"  let g:ctrlp_working_path_mode = 'cr'

  " Allow the cursor to go in to "invalid" places
  set virtualedit=block
" }

" CtrlP
  " no default input
  let g:ctrlp_default_input = 0
  " set working dir starting at vim's working dir
  let g:ctrlp_working_path_mode = 0
  let g:ctrlp_mruf_relative = 1
  let g:ctrlp_match_window = 'top,order:ttb,min:1,max:10,results:100'
  let g:ctrlp_prompt_mappings = {
    \ 'ToggleMRURelative()': ['<c-w>'],
    \ 'PrtDeleteWord()':     ['<F2>']
    \ }
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](local|blib|target)$'
    \ }
  let g:ctrlp_map = '<leader>ff'
  noremap <leader>fg :CtrlPRoot<CR>
  noremap <leader>fr :CtrlPMRU<CR>
  noremap <leader>fl :CtrlPMRU<CR>
  noremap <leader>ft :CtrlPTag<CR>
  noremap <leader>fb :CtrlPBuffer<CR>
  noremap <leader>fc :CtrlPClearCache<CR>
" }

" Text Formatting/Layout {
  set completeopt=menu,longest " improve the way autocomplete works
  set expandtab " no real tabs please!
  set formatoptions=rq " Automatically insert comment leader on return, and let gq work
  set ignorecase " case insensitive by default
  set nowrap " do not wrap line
  set shiftround " when at 3 spaces, and I hit > ... go to 4, not 5
  set smartcase " if there are caps, go case-sensitive
  " Indent Related {
    set shiftwidth=4 " unify
    set softtabstop=4 " unify
    set tabstop=4 " real tabs should be 4, but they will show with set list on
  " }

" }

let mapleader = ","
let NERDTreeShowBookmarks=1
map <leader>n :NERDTreeToggle<CR>
map <leader>nf :NERDTreeFind<CR>
cnoremap %% <C-R>=expand('%:h').'/'<CR>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-n> :tabnext<CR>
map <C-b> :tabprevious<CR>
cmap w!! w !sudo tee % >/dev/null
map <F8> :set paste!<CR>
nnoremap <silent> <F12> :bn<CR>
nnoremap <silent> <S-F12> :bp<CR>
" (:help smartindent) don't remove indentions on comments
inoremap # X#

" enable persistent undo
if v:version >= 703

  " ensure undo directory exists
  if !isdirectory("~/.vimundo")
    call system("mkdir ~/.vimundo")
  endif

  set undodir=~/.vimundo
  set undofile
  set undolevels=1000
  set undoreload=10000
endif

" Keep this at the end for final config overrides
if filereadable(expand("~/.vimrc.local.after"))
    source ~/.vimrc.local.after
endif
