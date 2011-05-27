call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin on
"colorscheme ir_black
set ofu=syntaxcomplete#Complete
set autoindent
set smartindent
" Perl {
  autocmd FileType perl set makeprg=perl\ -c\ %\ $*
  autocmd FileType perl set errorformat=%f:%l:%m
" }
" Basics {
  set nocompatible " explicitly get out of vi-compatible mode
  set background=dark " we plan to use a dark background
  syntax on " syntax highlighting on
  colorscheme solarized
  " Make sure that unsaved buffers that are to be put in the background are
  " allowed to go in there (ie. the "must save first" error doesn't come up)
  set hidden
" }

" Vim UI {
  set cursorcolumn " highlight the current column
  set cursorline " highlight current line
  set incsearch " BUT do highlight as you type you search phrase
  set laststatus=2 " always show the status line
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
  set shortmess=atI " shortens messages to avoid 'press a key' prompt
  set showcmd " show the command being typed
  set showmatch " show matching brackets
  set sidescrolloff=10 " Keep 5 lines at the size
  " statusline demo: ~\myfile[+] [FORMAT=format] [TYPE=type] [ASCII=000] [HEX=00] [POS=0000,0000][00%] [LEN=000]
  set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

  " Allow the cursor to go in to "invalid" places
  set virtualedit=insert
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
function! ToggleSyntax()
    if exists("g:syntax_on")
        syntax off
    else
        syntax enable
    endif
endfunction

" function to perl tidy
function PerlTidy()
    let ptline = line('.')
    if filereadable('/usr/bin/perltidy') || filereadable('/opt/local/bin/perltidy')
        %! perltidy -pbp -q -nasc -l=100
        "%! perltidy -pbp -nse -nst
    endif
    exe ptline
endfunction

" Show syntax highlighting groups for word under cursor
nmap ,sh :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" UltiSnips Configuration {
  set runtimepath+=~/.vim/bundle/ultisnips/UltiSnips
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" }

" Supertab Configuration {
  let g:SuperTabMappingForward = '<tab>'
  let g:SuperTabMappingBackward = "<s-tab>"
" }

" Compatibility {
  if version < 702
    let g:loaded_autoload_l9 = 1
    let g:disable_l9 = 1
  endif
" }

" Mappings {
  let mapleader = ","
  nmap <silent> ;s :call ToggleSyntax()<CR>
  noremap <silent> ,bd :bd<CR>
  map ,pt :call PerlTidy()<CR>
  let NERDTreeShowBookmarks=1
  map ,n :NERDTreeToggle<CR>
  map ,t  :CommandT<CR>
  imap jj <Esc>
  imap hh =>
  map <C-N> :tabnext<CR>
  map <C-P> :tabprev<CR>
  cnoremap %% <C-R>=expand('%:h').'/'<CR>
  map ,ew :e %%
  map ,es :sp %%
  map ,ev :vsp %%
  map ,et :tabe %%

  " Edit the vimrc file
  nmap <silent> ,er :e $MYVIMRC<CR>
  nmap <silent> ,sr :so $MYVIMRC<CR>

" }

" vim:shiftwidth=2:softtabstop=2:tabstop=2
