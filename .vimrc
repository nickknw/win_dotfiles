" vim: foldmethod=marker foldlevel=1 
"
" Basic Defaults {{{1
" --------------------------------
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
set viminfo='20,\"50	" read/write a .viminfo file, don't store more than 50 lines of registers
set history=50		" keep 50 lines of command line history
set showmode		" If in Insert, Replace or Visual mode put a message on the last line
set nu			" show line numbers
set display=lastline	" include as much of the last line as possible
set wildmenu		" better command autocompletion
set winaltkeys=no	" don't use alt keys for menus
set foldmethod=marker

" recommended for maximum politeness
set tabstop=8		
set softtabstop=4
set shiftwidth=4
set expandtab

" clever indenting
set autoindent
set smartindent

" searching related
set incsearch
set showmatch
set hlsearch
set smartcase

" When editing a file, always jump to the last cursor position
if has("autocmd") 
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
    \ | wincmd p | diffthis 


" More Personalized Settings {{{1
" --------------------------------

" share clipboard with Windows
set clipboard=unnamed  

" make sure I'm starting in my home dir, not Prog Files\Vim etc.
cd ~  

set gfn=DejaVu_Sans_Mono:h10
colo vc " I usually use desert or this

" preferred window size
set lines=25
set columns=80

" stop these files from being scattered all over
set backupdir=~\\vimfiles\\backup
set directory=~\\vimfiles\\swap

" no menus
if has("gui_running")
    set guioptions-=m "remove menu
    set guioptions-=T "remove toolbar
    set guioptions-=l "remove left scrollbar
    "set guioptions+=b
    "set nowrap
endif

" statusline related
set laststatus=2	"always show statusline
set showcmd		"show partial commands below statusline
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*fugitive#statusline')?fugitive#statusline():''}%*%=%-16(\ %l,%c%V\ %)%P\ of\ %L


" My Mappings {{{1
" --------------------------------

" best mapping ever - swap ; and :
noremap ; :
noremap : ;

"Change directory to the dir of the current buffer
noremap \cd :cd %:p:h<CR>  

" clear highlighting on <esc> press
nnoremap <esc> :noh<return><esc>

" Make C-BS and C-Del work like they do in most text editors for the sake of muscle memory
imap <C-BS> <C-W>
imap <C-Del> <esc>Ea<C-W>

" Windows-like copy/cut/paste mappings
" CTRL-V is Paste in insert mode
imap <C-V>		"+gpa   
" CTRL-C is Copy, CTRL-X is Cut, in visual mode
vmap <C-C>		"+y
vmap <C-x>		"+d
" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>		<C-V>

" Window switching
noremap <c-h> <c-w>h
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k
noremap <c-l> <c-w>l

" gf is 'go to file', gnf is now 'go to file in new window'
nnoremap gnf <c-w><c-f>

" make editing a temp macro in register q more convenient
noremap qp mqGo<Esc>"qp
noremap qd G0"qd$`q


" Plugin-related {{{1
" --------------------------------

"for vimwiki
filetype plugin on

nmap <silent> <F10> ;NERDTreeToggle<CR>

noremap \e :FufFileWithCurrentBufferDir **/<CR>
noremap \b :FufBuffer<CR>

" http://stackoverflow.com/questions/4294116/problem-with-vims-ruby-plugin
let g:ruby_path = ':C:\ruby192\bin'


" Filetype-specific commands {{{1
" --------------------------------

if has("autocmd")
  "html tag jumping with %
  autocmd FileType html let b:match_words = '<\(\w\w*\):</\1,{:}'
  autocmd FileType xhtml let b:match_words = '<\(\w\w*\):</\1,{:}'
  autocmd FileType smarty let b:match_words = '<\(\w\w*\):</\1,{:}'
  autocmd FileType xml let b:match_words = '<\(\w\w*\):</\1,{:}'
  
  " vb jumping with %
  let s:notend = '\%(\<end\s\+\)\@<!'
  autocmd FileType vbnet let b:match_words = '#Region:#End Region,' . s:notend . '\<If\>:\<End\s\+If\>,\<For\s\+Each\>:\<Next\>,' . s:notend . '\<Function\>:\<End Function\>'
  
  " special vbnet highlighting
  autocmd BufNewFile,BufRead *.vb set ft=vbnet
  au BufNewFile,BufRead *vb.wordfreq setf vbnet

   " In text files act like notepad
  autocmd BufRead *.txt set nowrap
  autocmd BufRead *.txt set go+=b

  " refresh fugitive status on gaining focus
  autocmd FocusGained * if !has('win32') | silent! call fugitive#reload_status() | endif
endif
" }}}2

