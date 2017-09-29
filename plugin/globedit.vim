" globedit.vim: Use globbing patterns for :edit, :tabedit, etc.
"
" http://arp242.net/code/globedit.vim
"
" See the bottom of this file for copyright & license information.
"

"##########################################################
" Initialize some stuff
scriptencoding utf-8
if exists('g:globedit') | finish | endif
let g:globedit = 1
let s:save_cpo = &cpo
set cpo&vim


"##########################################################
" Options
if !exists('g:multitabs_commands')
	let g:multitabs_commands = {
		\ 'tabedit': '',
		\ 'edit': '',
		\ 'split': '',
		\ 'vsplit': '',
	\}
endif


"##########################################################
" Commands
let s:tpl = 'command! -bar -bang -nargs=+ -complete=file %s call globedit#run("%s", [<f-args>])'
for [s:k, s:v] in items(g:multitabs_commands)
	execute printf(s:v != '' ? s:v : s:tpl,
		\ toupper(s:k[0]) . s:k[1:], s:k)
endfor


"##########################################################
" Functions

" cmd:          Command to run (e.g. edit, tabedit, etc.).
" pattern_list: List of filename patterns to open.
" ...:          Any other arguments will be eval-ed as-is for every new file
"               opened right after running cmd.
fun! globedit#run(cmd, pattern_list, ...)
	let l:command = a:0 > 0 ? a:1 : ''

	let l:found_one = 0

	for l:p in a:pattern_list
		for l:c in glob(l:p, 0, 1)
			let l:found_one = 1
			execute a:cmd . ' ' . fnameescape(l:c)
			if l:command != ''
				execute l:command
			endif
		endfor
	endfor

	if !l:found_one
		echoerr 'No match for ' . join(a:pattern_list)
	endif
endfun


let &cpo = s:save_cpo
unlet s:save_cpo


" The MIT License (MIT)
"
" Copyright © 2016 Martin Tournoij
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" The software is provided "as is", without warranty of any kind, express or
" implied, including but not limited to the warranties of merchantability,
" fitness for a particular purpose and noninfringement. In no event shall the
" authors or copyright holders be liable for any claim, damages or other
" liability, whether in an action of contract, tort or otherwise, arising
" from, out of or in connection with the software or the use or other dealings
" in the software.
