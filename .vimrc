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
set so=7                    " Set 7 lines to the cursor when moving vertically

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

syntax on                   " Syntax highlighting

" map esc to jk
imap jk <Esc>

set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set autoindent              " autoindenting
set backspace=2             " more powerful backspacing
set number                  " show line numbers
set ruler                   " show the cursor position
set cmdheight=2             " Height of command bar
set ignorecase              " ignore case when searching
set smartcase               " when searching try to be smart about cases
set hlsearch                " highlight search results
set incsearch               " makes search act like search in modern browsers
set foldcolumn=1            " Add a bit extra margin to the left

set encoding=utf8           " set utf-8 as standard encoding and en_US as standard language
set ffs=unix,dos,mac        " Set Unix as the standard file type
set showmatch               " show matching brackets when text indicator is over them
set mat=2                   " how many tenths of a second to blink when matching brackets


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
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" Activate Pathogen (in ~/.vim/autoload)
execute pathogen#infect()


" Open NerdTree automatically only if no files specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Toggle NerdTree with Ctrl + N
map <C-n> :NERDTreeToggle<CR>

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
