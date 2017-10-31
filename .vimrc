" Glen Myrland

set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=500		" keep 500 lines of command line history
set ruler		    " show the cursor position all the time
set showcmd		    " display incomplete commands
set incsearch		" do incremental searching
set number
set nowrap
set nobackup
set nohlsearch
set nospell

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
" if has('mouse')
"   set mouse=a
" endif

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=0

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Save folds
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" Save marks
set viminfo='100,f1

" Maximum tabs on startup
set tabpagemax=20

" Change tabs to spaces
set tabstop=4
set shiftwidth=4
set expandtab

set directory=~/.vim/swaps

" Read MS-Word documents
au BufReadPre *.doc set ro
au BufReadPre *.doc set hlsearch!
au BufReadPost *.doc silent! %!antiword "%"

" Read PDFs
au BufReadPre *.pdf set ro nowrap
au BufReadPost *.pdf silent %!pdftotext "%" -nopgbrk -layout -q -eol unix -
au BufWritePost *.pdf silent !rm -rf ~/PDF/%
au BufWritePost *.pdf silent !lp -s -d pdffg "%"
au BufWritePost *.pdf silent !until [ -e ~/PDF/% ]; do sleep 1; done
au BufWritePost *.pdf silent !mv ~/PDF/% %:p:h

" Turn off gui nonsense
set guioptions=
set guifont=DejaVu\ Sans\ Mono\ 9

" Color scheme
colorscheme industry

" The Tab key is mapped to Escape. Press Shift-Tab to insert a Tab.
" " To minimize Tab use, you can use '<', '>' and ':set autoindent
nnoremap <Tab> <Esc>
vnoremap <Tab> <Esc><Nul>| " <Nul> added to fix select mode problem
inoremap <Tab> <Esc>|
nnoremap <S-Tab> u<Tab><Esc><Right>
vnoremap <S-Tab> >dv|
inoremap <S-Tab> <Tab>|

nnoremap <space> <C-E>
nnoremap <backspace> <C-Y>

" Delete current line and append to time.txt in same dir with datestamp
" Used to track items cleared from todo list
function! WriteToTime()
  :.s/^/\=strftime('%Y-%m-%d').' '/
  let path = expand('%:p:h').'/time.txt'
  :execute '.write! >> ' . l:path
  :delete
endfunction
nnoremap <leader>d :call WriteToTime()<Cr>

" Prepend a timestamp on a line
nnoremap \n    0i<C-R>=strftime("%Y-%m-%d")<Return> - "<Esc>0f,l

" Center on cursor horizontally
nnoremap z<space> zszH

" Delete the file on the current line
nnoremap \rm Irm "<Esc>A"<Esc>V:!bash
