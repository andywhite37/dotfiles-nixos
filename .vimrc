" awhite .vimrc

" Load plugins via vim-plug
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'crusoexia/vim-monokai'
call plug#end()

" Other settings
noswapfile
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab

" Colors
colo torte
set guifont=Fira\ Code:h11
