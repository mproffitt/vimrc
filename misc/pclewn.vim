function! PyClewnInit()
    C tbreak main
    Cmapkeys
    unmap <CR>
endfunction

function! PyClewnPre()
    map <CR> :call PyClewnInit()<CR>
    0put ='Press <Enter> to start'
    setlocal buftype=nofile
endfunction

