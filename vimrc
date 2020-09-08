" Enable pathogen bundles
" See http://www.vim.org/scripts/script.php?script_id=2332
" Put github plugins under .vim/bundle/ -- which allows keeping them updated
" without having to do separate installation.
" Call "filetype off" first to ensure that bundle ftplugins can be added to the
" path before we re-enable it later in the vimrc.
filetype off
filetype plugin indent off

set rtp+=/usr/local/lib/python3.8/dist-packages/powerline/bindings/vim
set laststatus=2
set showtabline=2
set noshowmode
set t_Co=256

call plug#begin('~/.vim/plugged')
    Plug 'hashivim/vim-terraform'
    Plug 'vim-syntastic/syntastic'
    Plug 'juliosueiras/vim-terraform-completion'
    Plug 'vim-vdebug/vdebug'
    Plug 'tpope/vim-fugitive'
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    Plug 'Shougo/deoplete.nvim'
    Plug 'ervandew/supertab'
    Plug 'weierophinney/vimwiki.git'
    Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
call plug#end()

" Syntastic Config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Terraform settings
let g:syntastic_terraform_tffilter_plan = 1
let g:terraform_completion_keys = 1
let g:terraform_registry_module_completion = 0

" deoplete config
let g:deoplete#enable_at_startup = 1

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
set autoread

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
set history=10000
" don't duplicate an existing open buffer
set switchbuf=useopen

" Make backspace behave in a sane manner.
set backspace=indent,eol,start

" Switch syntax highlighting on
syntax on
set tags=$HOME/.vim.tags
helptags $HOME/.vim.tags


color blackboard
set colorcolumn=120

highlight Pmenu ctermbg=gray guibg=gray

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

let tagspath = "~/.vim.tags/"

" set the names of flags
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
"
"{{{html options
let html_use_css = 1
"}}}

au! BufRead,BufNewFile *.json set filetype=json
augroup json_autocmd
  autocmd!
  autocmd FileType json set autoindent
  autocmd FileType json set formatoptions=tcq2l
  autocmd FileType json set textwidth=78 shiftwidth=2
  autocmd FileType json set softtabstop=4 tabstop=4
  autocmd FileType json set expandtab
  autocmd FileType json set foldmethod=syntax
augroup END

set errorformat+=\"%f\"\\,%l\\,%c\\,%t%*[a-zA-Z]\\,\"%m\"

":cnoreabbrev wq w<bar>tabclose
":cnoreabbrev q bd<bar>q

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

call tabline#setup()
call bookcommands#setup()

noremap <silent> <F9> :cal VimCommanderToggle()<CR>

let NERDTreeIgnore = ['\.pyc$']

set lazyredraw
set ttyfast

if &term =~ '256color'
    set t_ut=
endif

