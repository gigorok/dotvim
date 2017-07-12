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
Plug 'w0rp/ale' " aync linter
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
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'tpope/vim-dispatch'
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips' " snippets supporting
Plug 'honza/vim-snippets' " snippets collection
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'sjl/gundo.vim'
call plug#end()

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>']
let g:ycm_key_list_previous_completion = ['<C-p>']
let g:SuperTabDefaultCompletionType = '<C-n>'
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsSnippetsDir = "~/.vim/snips"
let g:UltiSnipsSnippetDirectories = ["snips"]
let g:UltiSnipsEditSplit="vertical"

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
set synmaxcol=800

" identation
set autoindent
set smartindent

" set gui settings
" set guifont=Monaco:h13
" powerline supporting in MacVim
set guifont=Source\ Code\ Pro\ for\ Powerline:h12

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

set wrap

set list
set listchars=tab:▸\ ,eol:¬,trail:-,nbsp:+

set hlsearch
set path+=**

" CtrlP settings
filetype plugin indent on
syntax on
set runtimepath^=~/.vim/plugged/ctrlp.vim
let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" -U'
let g:ctrlp_use_caching = 0

" NERDTree
map <Leader>n :NERDTreeToggle<CR>
map <Leader>f :NERDTreeFind<CR>
let NERDTreeShowHidden = 1 " show hidden files by default

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme='luna'
let g:airline_powerline_fonts = 1

set background=dark " dark or light
colorscheme solarized
let g:solarized_termcolors=256

" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDDefaultAlign = 'left'

" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
let g:rspec_command = "Dispatch bin/rspec {spec}" " running specs through bin stub
let g:rspec_runner = "os_x_iterm2"

" ale, linting
let g:airline#extensions#ale#enabled = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 1
let g:ale_javascript_jshint_executable = '/usr/local/bin/jshint'

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

" This callback will be executed when the entire command is completed
function! BackgroundCommandClose(channel)
  " Read the output from the command into the quickfix window
  execute "cfile! " . g:backgroundCommandOutput
  " Open the quickfix window
  " copen
  unlet g:backgroundCommandOutput
endfunction

function! RunBackgroundCommand(command)
  " Make sure we're running VIM version 8 or higher.
  if v:version < 800
    echoerr 'RunBackgroundCommand requires VIM version 8 or higher'
    return
  endif

  if exists('g:backgroundCommandOutput')
    echo 'Already running task in background'
  else
    echo 'Running task in background'
    " Launch the job.
    " Notice that we're only capturing out, and not err here. This is because, for some reason, the callback
    " will not actually get hit if we write err out to the same file. Not sure if I'm doing this wrong or?
    let g:backgroundCommandOutput = tempname()
    call job_start(a:command, {'close_cb': 'BackgroundCommandClose', 'out_io': 'file', 'out_name': g:backgroundCommandOutput})
  endif
endfunction
command! -nargs=+ -complete=shellcmd RunBackgroundCommand call RunBackgroundCommand(<q-args>)
" stop spring
nnoremap <Leader>ss :RunBackgroundCommand spring stop<CR>

function! RunRawRspec(mode)
  let fn=expand('%:p') " full path
  if a:mode == 0
    let line=line('.') " getline('.') returns current row (string)
    execute "!bin/rspec " . fn . ":" . line
  else
    execute "!bin/rspec " . fn
  endif
endfunction
nnoremap <Leader>r :call RunRawRspec(0)<CR>
nnoremap <Leader>R :call RunRawRspec(1)<CR>

" Typos
command! -bang W w<bang>

" Visual Mode */# from Scrooloose
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

" Make sure Vim returns to the same line when you reopen a file.
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" autofixes
iab exmaple example
iab buebug byebug
