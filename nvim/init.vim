" Basic UI settings
set number              " Show line numbers
set relativenumber      " Show relative line numbers
set cursorline          " Highlight current line
set nowrap              " No line wrapping
syntax on               " Enable syntax highlighting
set termguicolors       " Enable 24-bit colors

" Tabs and indentation
set tabstop=4           " Number of spaces tabs count for
set shiftwidth=4        " Size of an indent
set expandtab           " Use spaces instead of tabs
set autoindent          " Copy indent from current line when starting a new line

" Clipboard (use system clipboard)
set clipboard=unnamedplus

" Search settings
set incsearch           " Incremental search
set ignorecase          " Ignore case in search
set smartcase           " But be case sensitive if uppercase is used

" Enable mouse support
set mouse=a

" Plugin manager (vim-plug) setup
call plug#begin('~/.local/share/nvim/plugged')

" Sensible defaults
Plug 'tpope/vim-sensible'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Autocomplete and language server client
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" Use <Tab> and <S-Tab> to navigate completion menu from coc.nvim
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Show diagnostic info from coc.nvim
nmap <silent> <leader>e :CocDiagnostics<CR>

" Set leader key to space
let mapleader = " "
