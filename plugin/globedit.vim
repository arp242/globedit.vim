scriptencoding utf-8
if exists('g:globedit') | finish | endif
let g:globedit = 1
let s:save_cpo = &cpo
set cpo&vim

if !exists('g:multitabs_commands')
	let g:multitabs_commands = {
		\ 'tabedit': '',
		\ 'edit':    '',
		\ 'split':   '',
		\ 'vsplit':  '',
	\}
endif

let s:tpl = 'command! -bar -bang -nargs=+ -complete=file %s call globedit#run("%s", [<f-args>])'
for [s:k, s:v] in items(g:multitabs_commands)
	exe printf(s:v != '' ? s:v : s:tpl, toupper(s:k[0]) . s:k[1:], s:k)
endfor

" cmd:          Command to run (e.g. edit, tabedit, etc.).
" pattern_list: List of filename patterns to open.
" ...:          Any other arguments will be eval-ed as-is for every new file
"               opened right after running cmd.
fun! globedit#run(cmd, pattern_list, ...) abort
	let l:command = a:0 > 0 ? a:1 : ''

	let l:errs = []
	for l:p in a:pattern_list
		if !s:has_glob(l:p)
			let l:globs = [l:p]
		else
			let l:globs = glob(l:p, 0, 1)
			if len(l:globs) is# 0
				call add(l:errs, l:p)
				continue
			endif
		endif

		for l:c in l:globs
			exe a:cmd . ' ' . fnameescape(l:c)
			if l:command isnot# ''
				exe l:command
			endif
		endfor
	endfor

	if len(l:errs) > 0
		echohl Error
		for l:e in l:errs
			echo 'globedit.vim: no matches for ' . l:e
		endfor
		echohl Normal
	endif
endfun

fun! s:has_glob(str) abort
	for l:c in ['*', '{', '[', '?']
		let l:i = stridx(a:str, '*')
		if l:i > -1 && a:str[l:c - 1] isnot# '\\'
			return 1
		endif
	endfor
	return 0
endfun


let &cpo = s:save_cpo
unlet s:save_cpo
