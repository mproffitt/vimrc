
function bookcommands#setup()

endfunction

" Switches on Book mode. Changes text width from 120 to 80 cols
function! Book()
    let g:BOOK=0
    setlocal spell spelllang=en_gb
    set colorcolumn=81
    set textwidth=80
    set nolist
endfunction
command! Book execute Book()

" Disables book mode.
function! NoBook()
    set nospell
    set colorcolumn=120
    set textwidth=0
    unlet g:BOOK
endfunction
command! NoBook execute NoBook()

function CompileTex()

endfunction()

function PreviewTex()

endfunction

