" sources VundleToPlug
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif
filetype plugin indent on

" Disables vi compatible mode, enabling more features
set nocompatible

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

set wildmenu
set path+=**      " :find will fuzzy search recursively for file

" Height of the command bar
set cmdheight=1

" Show matching brackets when text indicator is over them
set showmatch

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Save on losing focus
au FocusLost * :wa

" jump xml tags
runtime macros/matchit.vim

" Group for autocmd
augroup vimrcEx
  autocmd!

  " DROPBOX
  autocmd BufNewFile,BufRead *
    \ if expand('%:~') =~ '^\~/Dropbox' |
    \   set noswapfile |
    \ else |
    \   set swapfile |
    \ endif

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile,BufReadPost .{jscs,jshint,eslint}rc set filetype=json
augroup END

" required for ignores to apply
if exists("g:ctrlp_user_command")
    unlet g:ctrlp_user_command
endif
" Sane Ignore For ctrlp (ctrlp only, not wildignore)
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.yardoc\|public\/images\|public\/system\|data\|log\|tmp$',
  \ 'file': '\.exe$\|\.so$\|\.dat$\|\.swp$\|\.zip$'
  \ }

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Copy/Paste with system clipboard
"set clipboard=unnamedplus

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mouse & Scroll
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Scroll in vim-iTerm2 like in Terminal.app
set mouse=a
if !has('nvim')
  set ttymouse=xterm2
endif

" VIM proper mouse reporting rows/columns in big terminal window, (for)from iterm2.com
if has('mouse_sgr')
    set ttymouse=sgr
endif

" Slow terminal vim
set lazyredraw
set ttyfast


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" To keep current color setting
syntax enable
" For vim to overrule current terminal color setting
"syntax on

" To run base16 vim using 256 terminal (iterm theme or shell theme)
"let base16colorspace=256 " set above colorscheme

" 24bit color, default background = light
"colorscheme base16-default
"colorscheme base16-solarized
"colorscheme base16-atelierdune

" Transparent terminal backgrounds not displayed well with solarized
let g:solarized_termtrans = 1
colorscheme solarized
set background=dark " this is a gui-vim config

" Toggle Solarized background, conflicts with ctrlP
call togglebg#map("<F5>")

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Font
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" dz = dotted zero
" lg = linegap

" ! causes mvim to to no longer italicize comments
" Sets MacVim font (powerline) and size
"   Default for mvim is Menlo, which includes italic & bold typefaces
if has("gui_running")
   let s:uname = system("uname")
   if s:uname == "Darwin\n"
      "set guifont=Meslo\ LG\ M\ Regular\ for\ Powerline:h14
      set guifont=Source\ Code\ Pro:h14
   endif
endif

" ! Need a font that includes italic typefaces
" Italicize comments
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
highlight Comment gui=italic cterm=italic

" LaTeX conceal to utf8 glyphs
let g:tex_conceal = ""

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
" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
" tab follows shiftwidth on new lines
set smarttab

" Display extra whitespace
"set list listchars=tab:»·,trail:·,nbsp:·,eol:¬
set list listchars=tab:\ \ ,trail:·,nbsp:·

" Make it obvious where 80 characters is
set colorcolumn=80

" Auto hardwraps when formatoptions is not set
"set textwidth=80
" Disables textwidth autowrap, overrides possible by filetype
"set formatoptions-=tc

" Linebreak on 500 characters
"set lbr
"set tw=500

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

" Configure backspace so it acts as it should act
"set backspace=2   " same as 3 below, see help 'backspace'
"set backspace=indent
"set backspace=eol
"set backspace=start

" niceties
nnoremap ; :

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             Plugin Configurations

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTags!!
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Index ctags from any project, including those outside Rails
map <Leader>t :!ctags -R .<CR>

" Show Tagbar current file
nmap <Leader>b :TagbarToggle<CR>

let g:tagbar_type_css = {
\ 'ctagstype' : 'Css',
    \ 'kinds'     : [
        \ 'c:classes',
        \ 's:selectors',
        \ 'i:identities'
    \ ]
\ }


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autopen NERDTree and focus cursor in new document (window on the right)
"autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"shortcut to open NERDTree
map <leader>n :NERDTreeToggle<CR>

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"Show hidden files in NerdTree
let NERDTreeShowHidden=1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_mode_map = { 'passive_filetypes': ['html'] }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_eruby_ruby_quiet_messages =
    \ {"regex": "possibly useless use of a variable in void context"}


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-rspec mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>
nnoremap <Leader>a :call RunAllSpec()<CR>

" Run last session specs in currrent terminal (iTerm2 only)
let g:rspec_runner = "os_x_iterm2"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" YouCompleteMe
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Compilation flags file required for C & C++
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf_global.py'

