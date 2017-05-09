function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py
  endif
endfunction

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-unimpaired'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/nerdcommenter'
Plug 'albfan/nerdtree-git-plugin'
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'vim-ruby/vim-ruby'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-rails'
Plug 'thoughtbot/vim-rspec'
Plug 'airblade/vim-gitgutter'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'tpope/vim-dispatch'
call plug#end()

" set leader key
let mapleader = ','

" tmux navigation
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-l> :TmuxNavigateRight<CR>

" disable compatibility vim with vi
" or all Vim features will be disabled
set nocompatible
set number " show line numbers

" Treat .arb files as ruby
autocmd BufNewFile,BufRead *.html.arb setfiletype ruby

" Treat .rss files as XML
autocmd BufNewFile,BufRead *.rss setfiletype xml

" to not stuck vim while checking syntax of long lines
set synmaxcol=200

" identation
set autoindent
set smartindent

" set gui settings
set guifont=Monaco:h13

" enable per-directory .vimrc files supporting
set exrc
set secure

" natural splits
set splitbelow
set splitright

" add additional tags files
set tags+=gems.tags

" FOLDING
set foldmethod=syntax
set foldlevel=99

set updatetime=250 " default is about 4000 miliseconds

set noswapfile " disable creation of swap files

set nowrap

set list
set listchars=tab:▸\ ,eol:¬

set hlsearch
set path+=**

" vim-session - sessions management
let g:session_directory = "/tmp/" " will be lost after reboot
let g:session_extension = '.vimsession'
let g:session_autoload = 'no' " load needed session manually
let g:session_autosave = 'yes' " autosave current opened session
let g:session_menu = 0
let g:session_command_aliases = 1
nnoremap <Leader>so :OpenSession
nnoremap <Leader>ss :SaveSession
nnoremap <Leader>sd :DeleteSession<CR>
nnoremap <Leader>sc :CloseSession<CR>

" CtrlP settings
filetype plugin indent on
syntax on
set runtimepath^=~/.vim/plugged/ctrlp.vim
let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" -U'
let g:ctrlp_use_caching = 0
nnoremap <Leader>. :CtrlPTag<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>

" NERDTree
map <Leader>n :NERDTreeToggle<CR>
map <Leader>f :NERDTreeFind<CR>
let NERDTreeShowHidden = 1 " show hidden files by default

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme='luna'

set background=dark " dark or light
colorscheme solarized
let g:solarized_termcolors=256

" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDDefaultAlign = 'left'
map <C-c> <Plug>NERDCommenterToggle('n', 'Toggle')<CR>

" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
let g:rspec_command = "Dispatch bin/rspec {spec}" " running specs through bin stub
let g:rspec_runner = "os_x_iterm2"

" vim-syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_ruby_checkers = ['mri'] " or rubocop, but slow
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_javascript_jshint_exec = '/usr/local/bin/jshint'
let g:syntastic_scss_checkers = ['sass_lint']
let g:syntastic_eruby_ruby_quiet_messages =
    \ {"regex": "possibly useless use of a variable in void context"}

" Ruby Autocomplete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
let g:ycm_collect_identifiers_from_tags_files = 1

" to speed up grep using ag
set grepprg=ag\ --nogroup\ --nocolor\ --column\ --vimgrep
set grepformat=%f:%l:%c:%m,%f:%l:%m

set wildmenu
set wildmode=longest:list,full

" close the current buffer
map <Leader>q :bp\|bd #<CR>

