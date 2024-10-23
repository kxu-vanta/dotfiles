set nocompatible
syntax on
filetype plugin indent on

" Set up runtime path to include Vundle and initialize
" Make sure you install vundle plugins by running :PluginInstall
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'				" Vundle manages vundle, required.
Plugin 'junegunn/seoul256.vim'

call vundle#end()					" End of Vundle plugin

"set nocompatible            " dump old fashioned vi support! already set
set modelines=0				" prevents some security exploits..?
set ruler					" show curson position all the time
set showcmd					" display incomplete commands
set autoindent				" auto indent
set number					" line numbers
set showmode				" show what mode you're in
set mouse=a					" Enable use of mouse in console vim

" tabs and spaces
set expandtab
set tabstop=4				" tabs = 4 spaces
set softtabstop=4
set shiftwidth=4

set incsearch				" incremental search
set hlsearch				" highlight search terms
set ignorecase				" case insensitive search
set showmatch				" show matching parentheses
set incsearch				" works to highlight search text
set nowrap					" Don't auto wrap text when vim starts
set visualbell t_vb=		" Turn off flashing error screen

colo seoul256
let g:seoul256_background = 236
set background=dark

" syntax highlighting
" .vue files like html
au BufReadPost *.vue set syntax=html

" Set abbreviations for commonly misspelled words
iabbrev teh the
iabbrev adn and
iabbrev campaing campaign

" insert --> normal mode
nnoremap ; :
inoremap jk <Esc>
inoremap JK <Esc>

" Change the leader to comma
let mapleader= ","
let g:mapleader = ","

" j and k move up and down display lines vs. real lines
nnoremap j gj
nnoremap k gk

" Change the characters displayed after using 'set list'
set listchars=tab:▸\ ,eol:¬

" highlight trailing whitespace in red
match ErrorMsg '\s\+$'
