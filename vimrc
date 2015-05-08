" Enable pathogen bundles
" See http://www.vim.org/scripts/script.php?script_id=2332
" Put github plugins under .vim/bundle/ -- which allows keeping them updated
" without having to do separate installation.
" Call "filetype off" first to ensure that bundle ftplugins can be added to the
" path before we re-enable it later in the vimrc.
filetype off
filetype plugin indent off

" set runtimepath+=/usr/local/Cellar/go/1.2.1/libexec/misc/vim


" open files in tabs
"au BufAdd,BufNewFile,BufRead * nested tab sball

set rtp+=$HOME/.local/pythis2.7/site-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
call pathogen#infect()

" Use Vim settings, rather than Vi settings (much better!).
set nocompatible

" Disable the splash screen
set shortmess +=I

set hidden

set noai                         " set auto-indenting on for programming

set showcmd                      " display incomplete commnds
set list                         " show invisibles

set number                       " show line numbers
set ruler                        " show the current row and column
set hlsearch
set cursorline

set listchars=tab:▸\ ,eol:¬

" show fold column, fold by marker
set foldcolumn=2
set foldmethod=marker

" set tabwidth to 4 and use spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set encoding=utf-8

setlocal autoindent
setlocal smartindent
set visualbell t_vb=             " turn off error beep/flash
set novisualbell                 " turn off visual bell
set pastetoggle=<F2>             " toggle 'set paste'

" fast terminal for smoother rendering
set ttyfast

" turn off swap files
set noswapfile

" keep a lot of history
set history=100

" don't duplicate an existing open buffer
set switchbuf=useopen

" Make backspace behave in a sane manner.
set backspace=indent,eol,start

" Switch syntax highlighting on
syntax on
set tags=$HOME/.vim.tags
helptags $HOME/.vim.tags

" Load a tag file
" Loads a tag file from ~/.vim.tags/, based on the argument provided. The
" command "Ltag"" is mapped to this function.
function! LoadTags(file)
   let tagspath = $HOME . "/.vim.tags/" . a:file
   let tagcommand = 'set tags+=' . tagspath
   execute tagcommand
endfunction
command! -nargs=1 Ltag :call LoadTags("<args>")

" Enable file type detection and do language-dependent indenting.
filetype plugin indent on

set mouse=a
" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>


" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction


"php syntax options {{{
let php_sql_query = 1 "for SQL syntax highlighting inside strings
let php_htmlInStrings = 1 "for HTML syntax highlighting inside strings
"php_baselib = 1 "for highlighting baselib functions
"php_asp_tags = 1 "for highlighting ASP-style short tags
"php_parent_error_close = 1 "for highlighting parent error ] or )
"php_parent_error_open = 1 "for skipping an php end tag, if there exists an open ( or [ without a closing one
"php_oldStyle = 1 "for using old colorstyle
"php_noShortTags = 1 "don't sync <? ?> as php
let php_folding = 1 "for folding classes and functions
" }}}

let tagspath = "~/.vim.tags/"

" set the names of flags
let tlist_php_settings = 'php;c:class;f:function;d:constant;p:property'
" close all folds except for current file
let Tlist_File_Fold_Auto_Close = 1
" make tlist pane active when opened
let Tlist_GainFocus_On_ToggleOpen = 1
" width of window
let Tlist_WinWidth = 60
" close tlist when a selection is made
let Tlist_Close_On_Select = 1
" show the prototype
let Tlist_Display_Prototype = 1
" show tags only for current buffer
let Tlist_Show_One_File = 1
" call pathogen#infect()
"}}}
"{{{html options
let html_use_css = 1
"}}}

" phpDocumentor comment block generation
inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR>

" Run PHP linter on write
augroup php
  au BufNewFile,BufRead *.inc,*.php,*.html,*.ihtml,*.php3 set efm=%E,%C%m\ in\ %f\ on\ line\ %l,%CErrors\ parsing\ %f,%C,%Z
  au BufNewFile,BufRead *.inc,*.php,*.html,*.ihtml,*.php3 set makeprg=php\ -ddisplay_errors=on\ -l\ %
  au BufWritePost *.inc,*.php,*.html,*.ihtml,*.php3 :make
augroup END

" PHP Manual
autocmd FileType php set keywordprg=pman

" PHPUnit
autocmd FileType php noremap <Leader>u :w!<CR>:!phpunit -d memory-limit=1024M --strict --colors %<CR>

" PHP linter
autocmd FileType php noremap <C-L> :w!<CR>:!php -l %<CR>

" PHP Coding Standards
autocmd FileType php noremap <Leader>s :w!<CR>:!phpcs --standard=Plusnet %<CR>

function! RunPhpcs()
    let l:filename=@%
    let l:phpcs_output=system('phpcs --report=csv '.l:filename)
"    echo l:phpcs_output
    let l:phpcs_list=split(l:phpcs_output, "\n")
    unlet l:phpcs_list[0]
    cexpr l:phpcs_list
    cwindow
endfunction

set errorformat+=\"%f\"\\,%l\\,%c\\,%t%*[a-zA-Z]\\,\"%m\"
command! Phpcs execute RunPhpcs()

autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

function! Cp()
    set mouse=""
    set fdc=0
    set nonu
    set nolist
endfunction
command! Cp execute Cp()

function! NoCp()
    set mouse=a
    set fdc=2
    set nu
    set list
endfunction
command! NoCp execute NoCp()

imap <silent> <Down> <C-o>gj
imap <silent> <Up> <C-o>gk
nmap <silent> <Down> gj
nmap <silent> <Up> gk

noremap <F3> :call Svndiff("prev")<CR>
noremap <F4> :call Svndiff("next")<CR>
noremap <F5> :call Svndiff("clear")<CR>

autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

autocmd BufWritePre * :%s/\s\+$//e

command W w !sudo tee % > /dev/null

augroup filetypedetect
    au BufNewFile,BufRead *.xt  setf xt
augroup END

color blackboard
set colorcolumn=120

call tabline#setup()
call bookcommands#setup()

noremap <silent> <F9> :cal VimCommanderToggle()<CR>
