execute pathogen#infect()
call pathogen#infect()

" Set leader key, a prefix for user custom shortcuts
let mapleader = " "

" Still undecided about these
" set nobackup
" set nowritebackup
" set noswapfile

set history=50
set ruler         " show the cursor position all the time
set cursorline
set number
set incsearch     " do incremental searching,     hit n for next result
set hlsearch      " turns on search highlighting, C-r for last search
set showcmd
set autowrite     " Automatically :write before running commands

" Save on losing focus
au FocusLost * :wa

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Disables vi compatible mode, enabling more features
set nocompatible

" Height of the command bar
set cmdheight=1

" Configure backspace so it acts as it should act
set backspace=2   " Backspace deletes like most programs in insert mode
"set backspace=eol,start,indent

" Show matching brackets when text indicator is over them
set showmatch

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Scroll in vim-iTerm2 like in Terminal.app
set mouse=a
if !has('nvim')
  set ttymouse=xterm2
endif

" VIM proper mouse reporting rows/columns in big terminal window, (for)from iterm2.com
if has('mouse_sgr')
    set ttymouse=sgr
endif

" Copy/Paste with system clipboard
"set clipboard=unnamedplus

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Use markdown syntax for .md extension
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" sources VundleToPlug
"if filereadable(expand("~/.vimrc.bundles"))
"  source ~/.vimrc.bundles
"endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MacVim font
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" dz = dotted zero
" lg = linegap

" ! causes mvim to to no longer italicize comments
" Sets MacVim font (powerline) and size
"   Default for mvim is Menlo, which includes italic & bold typefaces
"if has("gui_running")
"   let s:uname = system("uname")
"   if s:uname == "Darwin\n"
"      set guifont=Meslo\ LG\ M\ Regular\ for\ Powerline:h14
"   endif
"endif

" ! Need a font that includes italic typefaces
" Italicize comments
highlight Comment gui=italic cterm=italic

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-rspec mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>
nnoremap <Leader>a :call RunAllSpec()<CR>

" Run last session specs in currrent terminal (iTerm2 only)
let g:rspec_runner = "os_x_iterm2"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Solarized stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" To keep current color setting
syntax enable
" For vim to overrule current terminal color setting
"syntax on
" Transparent terminal backgrounds not displayed well with solarized
let g:solarized_termtrans = 1
colorscheme solarized
set background=dark

" Toggle Solarized background
call togglebg#map("<F5>")

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Switching files, panes & windows
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <leader>w <C-w>w
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Cycle through listed buffers
:nnoremap <C-n> :bnext<CR>
:nnoremap <C-p> :bprevious<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab
" Be smart when using tabs ;)
set smarttab
" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Make it obvious where 80 characters is
set colorcolumn=80

" Auto hardwraps when formatoptions is not set
"set textwidth=80
" Disables textwidth autowrap, overrides possible by filetype
"set formatoptions-=tc

" Linebreak on 500 characters
"set lbr
"set tw=500

filetype plugin indent on

" Auto indent, problematic when pasting so use "*p
set ai
" Smart indent
set si
" Soft wrap lines to fit window
set wrap

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Automatically populate airline symbols dictionary
let g:airline_powerline_fonts = 1
" Smart tabline
let g:airline#extensions#tabline#enabled = 1

" Format the status line -> doesnt work
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" These lines setup the environment to show graphics and colors correctly.
set t_Co=256
"set term=xterm

" Reduce (leader key) timeout on delay when leaving insert mode with powerline
"set timeoutlen=50        " Default is 1000

" python powerline-status
"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_eruby_ruby_quiet_messages =
    \ {"regex": "possibly useless use of a variable in void context"}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autopen NERDTree and focus cursor in new document (window on the right)
"autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"shortcut to open NERDTree
map <C-n> :NERDTreeToggle<CR>

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"Show hidden files in NerdTree
let NERDTreeShowHidden=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Get off my lawn
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Left> :echoe "Use h"<CR>
inoremap <Left> <C-o>:throw "Use ESC h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
inoremap <Right> <C-o>:throw "Use ESC l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
inoremap <Up> <C-o>:throw "Use ESC k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
inoremap <Down> <C-o>:throw "Use ESC j"<CR>

" Allow left and right navigation to wrap between lines
set whichwrap+=<,>,h,l

" niceties
nnoremap ; :
inoremap jj <ESC>

