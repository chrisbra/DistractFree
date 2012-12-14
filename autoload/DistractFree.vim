" DistractFree.vim - A DarkRoom/WriteRoom like plugin
" -------------------------------------------------------------
" Version:	   0.2
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Last Change: Fri, 14 Dec 2012 21:50:35 +0100
"
" Script: http://www.vim.org/scripts/script.php?script_id=XXXX
" Copyright:   (c) 2009, 2010 by Christian Brabandt
"			   The VIM LICENSE applies to DistractFree.vim 
"			   (see |copyright|) except use "DistractFree.vim" 
"			   instead of "Vim".
"			   No warranty, express or implied.
"	 *** ***   Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts: XXX 2 :AutoInstall: DistractFree.vim
"
" Functions:
" (autoloaded) file

" Functions: "{{{1
" Output a warning message, if 'verbose' is set
fu! <sid>WarningMsg(text) "{{{2
	if empty(a:text)
		return
	endif
	let text = "DistractFree: ". a:text
	let v:errmsg = text
	if !&verbose
		return
	endif
	echohl WarningMsg
	unsilent echomsg text
	echohl None
endfu

fu! <sid>Init() " {{{2
    if !exists("s:distractfree_active")
        let s:distractfree_active   = 0
    endif
    " The desired column width.  Defaults to 90%
    if !exists( "g:distractfree_width" )
        let g:distractfree_width = '90%'
    endif

    " The colorscheme to load
    if !exists( "g:distractfree_colorscheme" )
        let g:distractfree_colorscheme = ""
    endif

    " The "scrolloff" value: how many lines should be kept visible above and below
    " the cursor at all times?  Defaults to 999 (which centers your cursor in the 
    " active window).
    if !exists( "g:distractfree_scrolloff" )
        let g:distractfree_scrolloff = 999
    endif

    if exists("g:distractfree_nomap_keys")
        let s:distractfree_nomap_keys = g:distractfree_nomap_keys
    endif

    " Should Vimroom clear line numbers from the Vimroomed buffer?  Defaults to `1`
    " (on). Set to `0` if you'd prefer Vimroom to leave line numbers untouched.
    " (Note that setting this to `0` will not turn line numbers on if they aren't
    " on already).
    if !exists( "g:distractfree_line_numbers" )
        let g:distractfree_line_numbers = 1
    endif
    " Given the desired column width, and minimum sidebar width, determine
    " the minimum window width necessary for splitting to make sense
    if match(g:distractfree_width, '%') > -1 && has('float')
        let s:minwidth  = float2nr(round(&columns * (matchstr(g:distractfree_width, '\d\+')+0.0)/100.0))
        let s:minheight = float2nr(round(&lines * (matchstr(g:distractfree_width, '\d\+')+0.0)/100.0))
    else
        " assume g:distractfree_width contains columns
        let s:minwidth = matchstr(g:distractfree_width, '\d\+')
        let s:minheight = s:minwidth/2
    endif
endfu

fu! <sid>LoadFile(cmd) " {{{2
	" Try to load a file. When the given file does not exists, return 0
	" on success return 1
	if empty(a:cmd)
		return
	endif
	let v:statusmsg = ""
	exe 'verbose sil ru ' . a:cmd
	if !empty(v:statusmsg)
		" file not found
		return 0
	else
		return 1
	endif
endfu

fu! <sid>SaveRestore(save) " {{{2
    if a:save
        let s:colors = g:colors_name
        let s:_a = 
            \ [ &l:t_mr, &l:so, &l:ls, &l:tw, &l:nu, &l:lbr, &l:wrap, &l:stl, &g:stl, &l:cul, &l:cuc, &l:go, &l:fcs, &l:ru ]
        if exists("+rnu")
            let s:_rnu = &l:rnu
        endif
        exe printf("setlocal t_mr= so=%s ls=0 tw=%s nonu nornu lbr wrap stl= nocul nocuc go=", g:distractfree_scrolloff, winwidth(winnr()))
        " Set statusline highlighting to normal hi group (so not displayed at all
        let &l:stl='%#Normal#'
        let &g:stl='%#Normal#'
		" Try to load the specified colorscheme
		if exists("g:distractfree_colorscheme") && !empty(g:distractfree_colorscheme)
			let colors = "colors/". g:distractfree_colorscheme . (g:distractfree_colorscheme[-4:] == ".vim" ? "" : ".vim")
			if !(<sid>LoadFile(colors))
				call <sid>WarningMsg("Colorscheme ". g:distractfree_colorscheme. " not found!")
			endif
		endif
        " Set highlighting
        for hi in ['VertSplit', 'NonText']
            call <sid>ResetHi(hi)
        endfor
    else
		unlet! g:colors_name
        exe "colors" s:colors
        let [ &l:t_mr, &l:so, &l:ls, &l:tw, &l:nu, &l:lbr, &l:wrap, &l:stl, &g:stl, &l:cul, &l:cuc, &l:go, &l:fcs, &l:ru ] = s:_a
        if exists("+rnu")
            let &l:rnu = s:_rnu
        endif
    endif
endfu

fu! <sid>ResetHi(group) "{{{2
	if !exists("s:default_hi")
		redir => s:default_hi | sil! hi Normal | redir END
	endif
	let s:default_hi = substitute(s:default_hi, '.*xxx\s*\(.*$\)', '\1', '')
	let s:default_hi = substitute(s:default_hi, '\w*fg=\S*', '', 'g')
	let s:default_hi = substitute(s:default_hi, '\(\w*\)bg=\(\S*\)', '\0 \1fg=\2', 'g')
	exe "sil hi" a:group s:default_hi
endfu

fu! <sid>NewWindow(cmd) "{{{2
    exe a:cmd
    sil! setlocal noma nocul nonu nornu buftype=nofile winfixwidth winfixheight
    let s:bwipe = bufnr('%')
    wincmd p
endfu

fu! <sid>MapKeys(enable) "{{{2
    if exists("s:distractfree_nomap_keys") && s:distractfree_nomap_keys
        return
    endif
	if !exists("s:mapped_keys")
		let s:mapped_keys = []
	endif
    let keys = {}
    " Order matters!
    let keys['n'] = ['<Up>', '<Down>', 'k', 'j']
    let keys['i'] = ['<Up>', '<Down>']
    if a:enable
        try
            call add(s:mapped_keys, maparg('<Up>', 'n', 0, 1))
            if !hasmapto('g<Up>', 'n')
                nnoremap <unique><buffer><silent> <Up> g<Up>
            endif
            call add(s:mapped_keys, maparg('<Down>', 'n', 0, 1))
            if !hasmapto('g<Down>', 'n')
                nnoremap  <unique><buffer><silent> <Down> g<Down>
            endif
            call add(s:mapped_keys, maparg('k', 'n', 0, 1))
            if !hasmapto('gk', 'n')
                nnoremap  <unique><buffer><silent> k gk
            endif
            call add(s:mapped_keys, maparg('j', 'n', 0, 1))
            if !hasmapto('gj', 'n')
                nnoremap  <unique><buffer><silent> j gj
            endif
            call add(s:mapped_keys, maparg('<Up>', 'i', 0, 1))
            if !hasmapto('<C-\><C-O><Up>', 'i')
                inoremap <unique><buffer><silent> <Up> <C-\><C-O><Up>
            endif
            call add(s:mapped_keys, maparg('<Down>', 'i', 0, 1))
            if !hasmapto('<C-\><C-O><Down>', 'i')
                inoremap <unique><buffer><silent> <Down> <C-\><C-O><Down>
            endif
        catch /E227:/
            " Noop: echo "Distractfree mappings already exist."
        catch /E225:/
            " Noop: echo "Distractfree global mappings already exist."
        endtry
    else
        " restore mappings keys, if they were mapped
        let index = 0
        for map in s:mapped_keys
            " key was not mapped
            if empty(map)
                let key = get(keys['n'] + keys['i'],index,0)
                if key != 0
                    exe "sil! nunmap <buffer>" key
                endif
            else
				let ounmap = (map.mode == 'nv')
                let cmd = ( ounmap ? '' : map.mode)
                let cmd .= (map.noremap ?  'nore' : ''). 'map '
                let cmd .= (map.silent ? '<silent>' : '')
                let cmd .= (map.buffer ? '<buffer>' : '')
                let cmd .= (map.expr ? '<expr>' : '')
                let cmd .= ' '
                let cmd .= map.lhs. ' '
                if map.sid && map.rhs =~# '<sid>'
                    let map.rhs = substitute(map.rhs, '\c<sid>', '<snr>'. map.sid. '_', '')
                endif
                let cmd .= map.rhs
                exe cmd
				if ounmap
					exe 'ounmap' map.lhs
				endif
            endif
            let index += 1
        endfor
        let s:mapped_keys = []
    endif
endfu

fu! DistractFree#DistractFreeToggle() "{{{2
    call <sid>Init()
    if s:distractfree_active == 1
        " Close upper/lower/left/right split windows
		" ignore errors
		exe "sil! ". s:bwipe. "bw"
        unlet! s:bwipe
        " Reset options
        call <sid>SaveRestore(0)
        " Reset mappings
        call <sid>MapKeys(0)
        if exists("g:distractfree_hook") && get(g:distractfree_hook, 'stop', 0) != 0
            exe g:distractfree_hook['stop']
        endif
    else
        let s:sidebar = (&columns - s:minwidth) / 2
        let s:lines = (&lines - s:minheight) / 2
        " Create the left sidebar
        call <sid>NewWindow("noa sil leftabove ".  s:sidebar. "vsplit new")
        " Create the right sidebar
        call <sid>NewWindow("noa sil rightbelow ". s:sidebar. "vsplit new")
        " Create the top sidebar
        call <sid>NewWindow("noa sil leftabove ".  s:lines.   "split new")
        " Create the bottom sidebar
        call <sid>NewWindow("noa sil rightbelow ". s:lines.   "split new")
        call <sid>SaveRestore(1)
        " Setup navigation over "display lines", not "logical lines" if
        " mappings for the navigation keys don't already exist.
        call <sid>MapKeys(1)
        if exists("g:distractfree_hook") && get(g:distractfree_hook, 'start', 0) != 0
            exe g:distractfree_hook['start']
        endif
    endif
    let s:distractfree_active = !s:distractfree_active
endfunction
" vim: ts=4 sts=4 fdm=marker com+=l\:\"
