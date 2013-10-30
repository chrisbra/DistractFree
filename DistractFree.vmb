" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
plugin/DistractFreePlugin.vim	[[[1
39
" DistractFreePlugin - Plugin for creating WriteRoom like state in Vim
" -------------------------------------------------------------
" Version:      0.5
" Maintainer:   Christian Brabandt <cb@256bit.org>
" Last Change: Wed, 14 Aug 2013 22:36:39 +0200
" Script:       http://www.vim.org/scripts/script.php?script_id=
" Copyright:    (c) 2009, 2010, 2011, 2012 by Christian Brabandt
"
"       The VIM LICENSE applies to DistractFree.vim
"       (see |copyright|) except use "DistractFree.vim"
"       instead of "Vim".
"       No warranty, express or implied.
"       *** *** Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts: 4357 5 :AutoInstall: DistractFree.vim

" Init: "{{{1
let s:cpo= &cpo
if exists("g:loaded_distract_free") || &cp
  finish
endif
set cpo&vim

" Parse Version line
let g:loaded_distract_free = matchstr(getline(3), '\.\zs\d\+') + 0

" Define the Commands " {{{2
command! -nargs=0 DistractFreeToggle call DistractFree#DistractFreeToggle()

" Define the Mapping: "{{{2
noremap <silent> <Plug>DistractFreeToggle    :DistractFreeToggle<CR>
" If no mapping exists, map it to `<Leader>W`.
if !hasmapto( '<Plug>DistractFreeToggle' )
    nmap <silent> <Leader>W <Plug>DistractFreeToggle
endif

" Restore: "{{{1
let &cpo=s:cpo
unlet s:cpo
" vim: ts=4 sts=4 fdm=marker et com+=l\:\"
doc/DistractFree.txt	[[[1
208
*DistractFree.txt*   A plugin for WriteRoom like Editing with Vim

Author:     Christian Brabandt <cb@256bit.org>
Version:    0.5 Wed, 14 Aug 2013 22:36:39 +0200
Copyright:  (c) 2009, 2010, 2011, 2012 by Christian Brabandt         
            The VIM LICENSE applies to DistractFree.txt
            (see |copyright|) except use DistractFree instead of "Vim".
            NO WARRANTY, EXPRESS OR IMPLIED.  USE AT-YOUR-OWN-RISK.


==============================================================================
Contents                                                        *DistractFree*
==============================================================================

        1.  DistractFree Manual.................|DistractFree-manual|
        2.  Configuration.......................|DistractFree-config|
                2.1 Window size.................|DistractFree-size|
                2.2 Set Colorscheme.............|DistractFree-Colorscheme|
                2.3 Remap keys..................|DistractFree-maps|
                2.4 Hooks.......................|DistractFree-hooks|
                2.5 Options.....................|DistractFree-options|
        3.  DistractFree Feedback...............|DistractFree-feedback|
        4.  DistractFree History................|DistractFree-history|

=================================================================================
1. DistractFree Manual                                       *DistractFree-manual*
=================================================================================

Functionality

This plugin has been made to enable a WriteRoom like behaviour in Vim.

When enabled, all unnecessary features are turned off, so you can concentrate
on writing with Vim. It also creates on each side a couple of empty windows,
so that the text will be centered around the screen.

This plugin defines the following commands:

:DistractFreeToggle

This commnd toggles between normal Vim mode and the distraction free mode.

Alternatively, you can use the key <leader>W in normal mode to toggle between normal
mode and Distraction Free mode. (If you haven't setup your leaderkey, see also
|<Leader>| use the '\' key)

==================================================================================
2 DistractFree Configuration                                   *DistractFree-config*
==================================================================================

2.1 Window width/height                                      *DistractFree-size*
-----------------------

By default, DistractFree create a frame around the main window, such that the
main buffer contains 90% of the available Vim window screen size. You can
change this, by specifying either a percentage or width (in columns) by
setting the g:distractfree_width variable, e.g. to have the window be resized
to 95% of the Vim window, put into your |.vimrc| the following: >

    :let g:distractfree_width = '95%'
<

2.2 Load a specific colorscheme                    *DistractFree-Colorscheme*
-------------------------------

By default, DistractFree does not change your colorscheme, although it comes
with an experimental Darkroom like colorscheme, called "darkroom".

DistractFree also does reset some highlighting colors, specifically it resets
|hl-VertSplit| and |hl-NonText|. You might however want to load a specific
colorscheme so that the highlighting distracts you even more. Therefore you
can set the variable g:distractfree_colorscheme to your prefered colorscheme,
which will then be loaded when starting distraction free mode like this >

        :let g:distractfree_colorscheme = "solarized"

This would make DistractFree try to load the specified colorscheme solarized
when entering distraction free mode. If you don't want to change your
colorscheme, simply set this variable to empty: >

        :let g:distractfree_colorscheme = ""

2.3 Remap keys                                *DistractFree-maps*
--------------

DistractFree remaps some keys, to make scrolling more easier. By default the
following keys are mapped: >
                            
    ┌───────┬─────────────────┐
    │  Key  │        Mapped To│
    ├───────┼─────────────────┤
    │   <Up>│            g<Up>│
    │ <Down>│          g<Down>│
    │      k│               gk│
    │      j│               gj│
    │ <Down>│   <C-\><C-O><Up>│
    │ <Down>│ <C-\><C-O><Down>│
    └───────┴─────────────────┘

If you prefer to have no keys being remaped, that the variable
g:distractfree_nomap_keys like this: >

    :let g:distractfree_nomap_keys = 1
<

2.4 Hooks                                             *DistractFree-hooks*
----------

If you want, you can execute certain scripts, whenever Distraction free mode
is started and stopped. For example, on Windows you might want to start
Distraction free mode in transparent mode using VimTweak
(http://www.vim.org/scripts/script.php?script_id=687). So to setup everything
on start, you set the variable g:distractfree_hook variable like this: >

    let g:distractfree_hook = {}
    let g:distractfree_hook.start = 'call libcallnr("vimtweak.dll", "SetAlpha", 210) |'. 
        \ 'call libcallnr("vimtweak.dll", "EnableMaximize", 1)  |'.
        \ 'call libcallnr("vimtweak.dll", "EnableCaption", 0)   |'.
        \ 'call libcallnr("vimtweak.dll", "EnableTopMost", 1) '

    let g:distractfree_hook.stop = 'call libcallnr("vimtweak.dll", "SetAlpha", 255) |'.
        \ 'call libcallnr("vimtweak.dll", "EnableMaximize", 0)  |'.
        \ 'call libcallnr("vimtweak.dll", "EnableCaption", 1)   |'.
        \ 'call libcallnr("vimtweak.dll", "EnableTopMost", 0)   |'

This setups a start hook, that will be executed on Distraction Free Mode start
(using the "start" key) and stop mode (using the "stop" key).

2.5 Options                                             *DistractFree-options*
------------
By default, DistractFree, resets several options, when entering distract free
mode. The following options will be set:

Option              Value
------              -----
cursorcolumn:       off
cursorline:         off
fillchars:          vert:|
guioptions:         empty
laststatus:         0
linebreak:          on
number:             off
relativenumber:     off
ruler:              off
scrolloff:          999
showtabline:        off
statusline:         empty
t_mr:               empty
textwidth:          width of window
wrap:               off

If you don't want a particular option to be remapped, that the option
g:distractfree_keep_options to the option name. For example to keep the number
option and the wrap option to their current values, set: >

    :let g:distractfree_keep_options = 'number,wrap'

<
==============================================================================
3. DistractFree Feedback                                 *DistractFree-feedback*
==============================================================================

Feedback is always welcome. If you like the plugin, please rate it at the
vim-page: http://www.vim.org/scripts/script.php?script_id=4357

You can also follow the development of the plugin at github:
http://github.com/chrisbra/DistractFree

Bugs can also be reported there:
https://github.com/chrisbra/DistractFree/issues

Alternatively, you can also report any bugs to the maintainer, mentioned in the
third line of this document. Please don't hesitate to contact me, I won't bite
;)

If you like the plugin, write me an email (look in the third line for my mail
address). And if you are really happy, vote for the plugin and consider
looking at my Amazon whishlist: http://www.amazon.de/wishlist/2BKAHE8J7Z6UW

==============================================================================
4. DistractFree History                                   *DistractFree-history*
==============================================================================

0.5: Aug 14, 2013 {{{1
- updated documentation by Ingo Karkat, Thanks!, issue #1
- Make State of plugin avaivable to extern (patch by Ingo Karkat, Thanks!,
  issue #2)
- Ensure, padding of 'stl' works correctly (patch by Ingo Karkat, Thanks!,
  issue #3)
- :q in DistractMode quits vim correctly
- Save/Restore User highlighting

0.4: Feb 16, 2013 {{{1
- set/restore guifont
- updated colorscheme
- remove font attribute from Normal highlighting
- make current window the only window
0.3: Dec 15, 2012 {{{1
- enable |:GLVS|
0.2: Dec 14, 2012 {{{1
- upload to vim.org
0.1: Dec 14, 2012 {{{1
- first internal version
  }}}

==============================================================================
Modeline:
vim:tw=78:ts=8:ft=help:et:fdm=marker:fdl=0:norl
autoload/DistractFree.vim	[[[1
382
" DistractFree.vim - A DarkRoom/WriteRoom like plugin
" -------------------------------------------------------------
" Version:	   0.5
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Last Change: Wed, 14 Aug 2013 22:36:39 +0200
"
" Script: http://www.vim.org/scripts/script.php?script_id=4357
" Copyright:   (c) 2009 - 2013 by Christian Brabandt
"			   The VIM LICENSE applies to DistractFree.vim 
"			   (see |copyright|) except use "DistractFree.vim" 
"			   instead of "Vim".
"			   No warranty, express or implied.
"	 *** ***   Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts: 4357 5 :AutoInstall: DistractFree.vim
"
" Functions:
" (autoloaded) file

" Functions: "{{{1
" Output a warning message, if 'verbose' is set
fu! <sid>WarningMsg(text, force) "{{{2
	if empty(a:text)
		return
	endif
	let text = "DistractFree: ". a:text
	let v:errmsg = text
	if !&verbose && !a:force
		return
	endif
	echohl WarningMsg
	unsilent echomsg text
	echohl None
endfu

let s:distractfree_active = 0
fu! <sid>Init() " {{{2
    " The desired column width.  Defaults to 90%
    if !exists( "g:distractfree_width" )
        let g:distractfree_width = '90%'
    endif

    " The colorscheme to load
    if !exists( "g:distractfree_colorscheme" )
        let g:distractfree_colorscheme = ""
    endif

    " The font to use
    if !exists( "g:distractfree_font" )
        let g:distractfree_font = ""
    endif


    if exists("g:distractfree_nomap_keys")
        let s:distractfree_nomap_keys = g:distractfree_nomap_keys
    endif

	" Set those options to their values in distractfree mode, if you don't
	" want them to be set, set the option g:distractfree_keep_options to
	" include the option values
	"
    " The "scrolloff" value: how many lines should be kept visible above and below
    " the cursor at all times?  Defaults to 999 (which centers your cursor in the 
    " active window).
	let s:_def_opts = {'t_mr': '', 'scrolloff': get(g:, 'distractfree_scrolloff', 999), 'laststatus': 0,
				\ 'textwidth': winwidth(winnr()), 'number': 0, 'relativenumber': 0, 'linebreak': 1, 'wrap': 0,
				\ 'g:statusline': '%#Normal#', 'l:statusline': '%#Normal#', 'cursorline': 0, 'cursorcolumn': 0,
				\ 'ruler': 0, 'guioptions': '', 'fillchars':  'vert:|', 'showtabline': 0}

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
	if !exists("s:sessionfile")
		let s:sessionfile = tempname()
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
		let s:main_buffer = bufnr('')
		if exists("g:colors_name")
			let s:colors = g:colors_name
			let s:higroups = <sid>SaveHighlighting('User')
		endif
		if !empty(g:distractfree_font)
			let s:guifont = &guifont
			sil! let &guifont=g:distractfree_font
		endif

		let s:_opts = {}

		for opt in keys(s:_def_opts)
			if match(get(g:, 'distractfree_keep_options', ''), opt) > -1
				continue
			elseif exists("+". (opt=~ '^[glw]:' ? opt[2:] : opt))
				if (opt == 'g:statusline' && get(g:, 'loaded_airline', 0) && exists(":AirlineToggle") == 2)
					" Disable airline statusline
					:AirlineToggle
				endif
				exe 'let s:_opts["'.opt. '"] = &'. (opt =~ '^[glw]:' ? '' : 'l:'). opt
				exe 'let &'. (opt =~ '^[glw]:' ? '' : 'l:').opt. '="'. s:_def_opts[opt].'"'
			endif
		endfor
		" Try to load the specified colorscheme
		if exists("g:distractfree_colorscheme") && !empty(g:distractfree_colorscheme)
			let colors = "colors/". g:distractfree_colorscheme . (g:distractfree_colorscheme[-4:] == ".vim" ? "" : ".vim")
			if !(<sid>LoadFile(colors))
				call <sid>WarningMsg("Colorscheme ". g:distractfree_colorscheme. " not found!",0)
			endif
		endif
        " Set highlighting
        for hi in ['VertSplit', 'NonText', 'SignColumn']
            call <sid>ResetHi(hi)
        endfor
    else
		unlet! s:main_buffer
		unlet! g:colors_name
		if exists("s:colors")
			exe "colors" s:colors
			for item in s:higroups
				exe "sil!" item
			endfor
		endif
		if exists("s:guifont")
			let &guifont = s:guifont
		endif
		for [opt, val] in items(s:_opts)
			if (opt == 'g:statusline' && get(g:, 'loaded_airline', 0) && exists(":AirlineToggle") == 2)
				" Disable airline statusline
				:AirlineToggle
			endif
			exe 'let &'.(opt =~ '^[glw]:' ? '' : 'l:').opt. '="'. val.'"'
		endfor

"        let [ &l:t_mr, &l:so, &l:ls, &l:tw, &l:nu, &l:lbr, &l:wrap, &l:stl, &g:stl, &l:cul, &l:cuc, &l:go, &l:fcs, &l:ru ] = s:_a
"        if exists("+rnu")
"            let &l:rnu = s:_rnu
"        endif
    endif
endfu

fu! <sid>ResetHi(group) "{{{2
	if !exists("s:default_hi")
		redir => s:default_hi | sil! hi Normal | redir END
		let s:default_hi = substitute(s:default_hi, 'font=.*$', '', '')
		let s:default_hi = substitute(s:default_hi, '.*xxx\s*\(.*$\)', '\1', '')
		let s:default_hi = substitute(s:default_hi, '\w*fg=\S*', '', 'g')
		let s:default_hi = substitute(s:default_hi, '\(\w*\)bg=\(\S*\)', '\0 \1fg=\2', 'g')
	endif
	if s:default_hi == 'cleared'
		exe "sil syn clear" a:group
	else
		exe "sil hi" a:group s:default_hi
	endif
endfu

fu! <sid>NewWindow(cmd) "{{{2
    exe a:cmd
    sil! setlocal noma nocul nonu nornu buftype=nofile winfixwidth winfixheight nobuflisted bufhidden=wipe
    let &l:stl='%#Normal#'
    let s:bwipe = bufnr('%')
	augroup DistractFreeWindow
		au!
		au BufEnter <buffer> call <sid>BufEnterHidden()
		if exists("##QuitPre")
			au QuitPre <buffer> bw
		endif
	augroup END
    noa wincmd p
endfu

fu! <sid>BufEnterHidden() "{{{2
	let &l:stl = '%#Normal#'
	if !bufexists(s:main_buffer) ||
		\ !buflisted(s:main_buffer) ||
		\ !bufloaded(s:main_buffer) ||
		\ bufwinnr(s:main_buffer) == -1
		exe s:bwipe "bw!"
	else
		noa wincmd p
	endif
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

fu! <sid>SaveHighlighting(pattern) "{{{2
	" Save and Restore User1-User10 highlighting
    redir => a|exe "sil hi"|redir end
    let b = split(a[1:], "\n")
    call filter(b, 'v:val !~ ''\(links to\)\|cleared''')
    let i = 0
    while i < len(b)
		let b[i] = substitute(b[i], 'xxx', '', '')
		if i > 0 && b[i] =~ '^\s\+'
			let b[i-1] .= ' '. join(split(b[i]), " ")
			call remove(b, i)
		else
			let i+=1
		endif
    endw
	call map(b, '''hi ''. v:val')
    return filter(b, 'v:val=~a:pattern')
endfu

fu! <sid>SaveRestoreWindowSession(save) "{{{2
	if a:save
		let _so = &ssop
		let &ssop = 'blank,buffers,curdir,folds,help,unix,tabpages,winsize'
		exe ':mksession!' s:sessionfile
		let &ssop = _so
	else
		if exists("s:sessionfile") && filereadable(s:sessionfile)
			exe ":sil so" s:sessionfile
			"call delete(s:sessionfile)
		endif
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
		" Reset closing autocommand
		if exists("#DistractFreeMain")
			augroup DistractFreeMain
				au!
			augroup END
			augroup! DistractFreeMain
		endif
		call <sid>SaveRestoreWindowSession(0)
        if exists("g:distractfree_hook") && get(g:distractfree_hook, 'stop', 0) != 0
            exe g:distractfree_hook['stop']
        endif
    else
		call <sid>SaveRestoreWindowSession(1)
		try
			sil wincmd o
		catch
			" wincmd o does not work, probably because of other split window
			" which have not been saved yet
			call <sid>WarningMsg("Can't start DistractFree mode, other windows contain non-saved changes!", 1)
			return
		endtry
        call <sid>SaveRestore(1)
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
        " Setup navigation over "display lines", not "logical lines" if
        " mappings for the navigation keys don't already exist.
        call <sid>MapKeys(1)

		" Set autocommand for closing the sidebar
		if exists("##QuitPre")
			augroup DistractFreeMain
				au!
				au QuitPre <buffer> :exe "noa sil! ". s:bwipe. "bw"
				au VimLeave * :call delete(s:sessionfile)
			augroup END
		endif

        if exists("g:distractfree_hook") && get(g:distractfree_hook, 'start', 0) != 0
            exe g:distractfree_hook['start']
        endif
		" exe "windo | if winnr() !=".winnr(). "|let &l:stl='%#Normal#'|endif"
    endif
    let s:distractfree_active = !s:distractfree_active
endfunction

fu! DistractFree#Active() "{{{2
	return s:distractfree_active
endfunction
" vim: ts=4 sts=4 fdm=marker com+=l\:\"
colors/darkroom.vim	[[[1
38
" Vim WriteRoom/DarkRoom/OmniWrite like colorscheme
" Maintainer:   Christian Brabandt <cb@256bit.org>
" Last Change:  2012

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="distractfree"

hi Statement    ctermfg=DarkCyan    ctermbg=Black	guifg=DarkCyan      guibg=Black
hi Constant     ctermfg=DarkCyan    ctermbg=Black     	guifg=DarkCyan	    guibg=Black
hi Identifier   ctermfg=Green	    ctermbg=Black     	guifg=Green	    guibg=Black
hi Type         ctermfg=DarkCyan    ctermbg=Black     	guifg=DarkCyan	    guibg=Black
hi String       ctermfg=Cyan	    ctermbg=Black     	guifg=Cyan	    guibg=Black
hi Boolean      ctermfg=DarkCyan    ctermbg=Black     	guifg=DarkCyan	    guibg=Black
hi Number       ctermfg=DarkCyan    ctermbg=Black     	guifg=DarkCyan	    guibg=Black
hi Special      ctermfg=DarkGreen   ctermbg=Black     	guifg=darkGreen     guibg=Black
hi Scrollbar    ctermfg=DarkCyan    ctermbg=Black     	guifg=DarkCyan      guibg=Black
hi Cursor       ctermfg=Black	    ctermbg=Green     	guifg=Black	    guibg=Green
hi WarningMsg   ctermfg=Yellow	    ctermbg=Black	guifg=Yellow	    guibg=Black
hi Directory    ctermfg=Green	    ctermbg=DarkBlue	guifg=Green	    guibg=DarkBlue
hi Title        ctermfg=White	    ctermbg=DarkBlue	guifg=White	    guibg=DarkBlue 
hi Cursorline   ctermfg=Black	    ctermbg=DarkGreen	guibg=darkGreen	    guifg=black
hi Normal       ctermfg=Green	    ctermbg=Black	guifg=Green	    guibg=Black
hi PreProc      ctermfg=DarkGreen   ctermbg=Black     	guifg=DarkGreen	    guibg=Black
hi Comment      ctermfg=darkGreen   ctermbg=Black     	guifg=darkGreen	    guibg=Black
hi LineNr       ctermfg=Green	    ctermbg=Black	guifg=Green	    guibg=Black
hi ErrorMsg     ctermfg=Red	    ctermbg=Black     	guifg=Red	    guibg=Black
hi Visual       ctermfg=White	    ctermbg=DarkGray	cterm=underline	    guifg=White		guibg=DarkGray	gui=underline
hi Folded       ctermfg=DarkCyan    ctermbg=Black     	cterm=underline	    guifg=DarkCyan	guibg=Black	gui=underline

" Reset by distract free
" hi NonText      ctermfg=Black  ctermbg=Black guifg=black  guibg=Black
" hi VertSplit    ctermfg=Black     ctermbg=Black guifg=black     guibg=Black
" hi StatusLine   cterm=bold,underline ctermfg=White ctermbg=Black term=bold gui=bold,underline guifg=White guibg=Black
" hi StatusLineNC cterm=bold,underline ctermfg=Gray  ctermbg=Black term=bold gui=bold,underline guifg=Gray  guibg=Black 
