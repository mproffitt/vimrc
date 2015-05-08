" Function to set vim tab title
"
" This function will set the tab title as:
"     <TAB_NUM> <FILENAME>
"
" example:
"     1 vimrc | 2 satis.json | 3 [B] book.tex

function tabline#setup()
    set stal=2
    set tabline=%!TabLine()
endfunction

if exists("+showtabline")
    function TabLine()
        let s = ''
        for t in range(tabpagenr('$'))
            if t + 1 == tabpagenr()
                let s .= '%#TabLineSel#'
            else
                let s .= '%#TabLine#'
            endif
            let s .= ' '
            let s .= '%' . (t + 1) . 'T'
            let s .= t + 1 . ' '
            let n = ''
            let m = 0
            let bc = len(tabpagebuflist(t + 1))
            for b in tabpagebuflist(t + 1)
                if getbufvar( b, "&buftype" ) == 'help'
                    let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
                elseif getbufvar( b, "&buftype" ) == 'quickfix'
                    let n .= '[Q]'
                elseif exists('g:BOOK')
                    let n .= '[B] ' . fnamemodify(bufname(b), ':t')
                else
                    let n .= fnamemodify(bufname(b), ':t')
                endif

                if getbufvar( b, "&modified" )
                    let m += 1
                endif

                if bc > 1
                    let n .= ' '
                endif
                let bc -= 1
            endfor

            if m > 0
                let s.= '+ '
            endif

            if n == ''
                let s .= '[No Name]'
            else
                let s .= n
            endif

            let s .= ' '
        endfor

        let s .= '%#TabLineFill#%T'

        if tabpagenr('$') > 1
            let s .= '%=%#TabLine#%999XX'
        endif

        return s
    endfunction


endif

