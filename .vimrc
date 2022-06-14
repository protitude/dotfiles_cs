scriptencoding utf-8
set encoding=utf-8
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'StanAngeloff/php.vim'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'airblade/vim-gitgutter'
Plugin 'joonty/vim-phpqa'
Plugin 'phpcomplete.vim'
"Plugin 'SuperTab'
"Plugin 'scrooloose/syntastic'
Plugin 'tomtom/tlib_vim'
Plugin 'suan/vim-instant-markdown'
" Drupal Plugins
Plugin 'http://git.drupal.org/project/vimrc.git', {'name': 'vim-plugin-for-drupal', 'rtp': 'bundle/vim-plugin-for-drupal/'}
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdcommenter'
" Plugin 'maxboisvert/vim-simple-complete'
Plugin 'msanders/snipmate.vim'
Plugin 'scrooloose/syntastic'
Plugin 'majutsushi/tagbar'
Plugin 'evidens/vim-twig'
" Plugin 'joonty/vdebug'
Plugin 'surround.vim'
Plugin 'vimwiki/vimwiki'
Plugin 'Lokaltog/powerline'
" https://github.com/adoy/vim-php-refactoring-toolbox
Plugin 'adoy/vim-php-refactoring-toolbox'

" Persistent Undo: https://jovicailic.org/2017/04/vim-persistent-undo
set undofile " Maintain undo history between sessions
set undodir=~/.vim/undodir

" Set vimwiki to markdown
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" Set the codesniffer args
let g:phpqa_codesniffer_args = "--standard=Zend"
let g:phpqa_messdetector_ruleset = "~/drush/vendor/phpunit/phpunit/build/phpmd.xml"
" Slow down markdown preview
let g:instant_markdown_slow = 1
" Syntatic settings
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_enable_balloons = 1
let g:syntastic_auto_loc_list=1
let g:syntastic_mode_map = { 'mode': 'active',
            \                   'active_filetypes' : [],
            \                   'passive_filetypes' : ['php'] }
let g:syntastic_filetype_map = { 'html.twig.drupal': 'twig' }
" Status Line
set showmode "show current mode down the bottom
"set tags=/web/cuboulder/data/releases/oit/master/php.tags
set cursorline          " highlight the current line

"Set autocomplete maxboisvert/vim-simple-complete
set complete-=t
set complete-=i

"Setting the status line... {{{

set statusline=%f
""tail of the filename

"display a warning if the file format isn't Unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*
"
""display a warning if file encoding isn't UTf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h      "help file flag
set statusline+=%y      "filetype
set statusline+=%r      "read only flag
set statusline+=%m      "modified flag
"end status line }}}

" Remove trailing whitespace on save
autocmd BufWritePre * if &ft!~?'markdown'|:%s/\s\+$//e

" Set markdown file type
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Automatically turn on spell check and completion for markdown files
autocmd BufRead,BufNewFile *.md setlocal spell
set complete+=kspell

" ctr+j will insert break.
:nnoremap <NL> i<CR><ESC>

set number
set colorcolumn=80
" Share with clipboard
set clipboard=unnamed
" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·
syntax enable
colorscheme monokai
set background=dark
" Highlight search results
" set hlsearch
set hls is ic
" Allow backspace in insert mode
set backspace=indent,eol,start
" Indentation https://www.drupal.org/node/29325
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set smarttab            " better backspace and tab functionality
" bells
set noerrorbells        " turn off audio bell
set visualbell          " but leave on a visual bell

" Filetypes
if has("autocmd")
  filetype plugin on      " enable filetype-specific plugins
  " Treat .json files as .js
  autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
  " Treat .md files as Markdown
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
  " Drupal *.module and *.install files.
  augroup module
    autocmd BufRead,BufNewFile *.module set filetype=php
    autocmd BufRead,BufNewFile *.install set filetype=php
    autocmd BufRead,BufNewFile *.test set filetype=php
    autocmd BufRead,BufNewFile *.inc set filetype=php
    autocmd BufRead,BufNewFile *.profile set filetype=php
    autocmd BufRead,BufNewFile *.view set filetype=php
  augroup END
  autocmd BufNewFile,BufRead *.twig   set syntax=html
endif
