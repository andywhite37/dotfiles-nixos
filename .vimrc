" awhite .vimrc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin()
Plug 'tpope/vim-sensible'
if $USER == "awhite"
  Plug 'scrooloose/nerdtree'
  Plug 'crusoexia/vim-monokai'
endif
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General vim settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

noswapfile
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color scheme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if $USER == "awhite"
  colorscheme monokai
else
  colorscheme torte
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Font
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set guifont=Fira\ Code:h11

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if $USER == "awhite"
  " Show hidden files by default
  let g:NERDTreeShowHidden = 1

  " Start NERDTree automatically
  autocmd VimEnter * NERDTree
  autocmd BufEnter * NERDTreeMirror

  " Focus the editor buffer automatically (navigate to the right)
  autocmd VimEnter * wincmd l
  autocmd BufNew * wincmd l

  " Close vim when NERDTree is the only buffer left
  " https://github.com/scrooloose/nerdtree/issues/21
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif
