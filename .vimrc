" Vim Configuration File

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set history=500             " Sets how many lines of history VIM has to remember
filetype plugin indent on   " Use the file type plugins
set noswapfile              " No swap files when editing


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set so=5                    " Maintain 5 lines of context for cursor

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

syntax on                   " Syntax highlighting

" Map esc to jk
imap jk <Esc>

" Map window switching to Ctrl + Arrows
map <C-Down> <C-W>j
map <C-Up> <C-W>k
map <C-Left> <C-W>h
map <C-Right> <C-W>l

" Map window maximizing to Ctrl + _
map <C-_> <C-W>_

" Info on the following section can be found with :help set
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set autoindent                  " Autoindenting
set backspace=indent,eol,start  " More powerful backspacing
set number                      " Show line numbers
set ruler                       " Show the cursor position
set cursorline                  " Highlight cursor position
set cmdheight=1                 " Height of command bar
set ignorecase                  " Ignore case when searching
set smartcase                   " Be smart about cases when searching
set hlsearch                    " Highlight search results
set incsearch                   " Make search act like search in modern browsers
set showmatch                   " Show matching brackets when cursor is on one
set mat=2                       " Tenths of a second to blink when matching brackets
set foldcolumn=1                " Add a bit extra margin to the left
set visualbell                  " Disable sounds on error
set vb t_vb=""                  " Disable screen flash on error

set encoding=utf8               " Set utf-8 as standard encoding and en_US as standard language
set ffs=unix,dos,mac            " Set Unix as the standard file type


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on                   " Enable syntax highlighting
try
    colorscheme itg_flat
catch
endtry

set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c\ (%P)


""""""""""""""""""""""""""""""
" => Misc
""""""""""""""""""""""""""""""
" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\ if ! exists("g:leave_my_cursor_position_alone") |
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\ exe "normal g'\"" |
\ endif |
\ endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction
