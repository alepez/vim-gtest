" ============================================================================
" Maintainer:  Alessandro Pezzato <http://pezzato.net/>
" License:     The MIT License (MIT)
" ============================================================================

" Thanks to the creator of https://github.com/fisadev/vim-ctrlp-cmdpalette,
" which allowed me to learn how to extend CtrlP.

let g:loaded_ctrlp_gtest = 1

" The main variable for this extension.
"
" The values are:
" + the name of the input function (including the brackets and any argument)
" + the name of the action function (only the name)
" + the long and short names to use for the statusline
" + the matching type: line, path, tabs, tabe
"                      |     |     |     |
"                      |     |     |     `- match last tab delimited str
"                      |     |     `- match first tab delimited str
"                      |     `- match full line like file/dir path
"                      `- match full line
let s:gtest_var = {
	\ 'init': 'ctrlp#gtest#init()',
	\ 'accept': 'ctrlp#gtest#accept',
	\ 'lname': 'gtest',
	\ 'sname': 'gtest',
	\ 'type': 'line',
	\ 'sort': 0,
	\ }

if !exists('g:ctrlp_gtest_execute')
  let g:ctrlp_gtest_execute = 0
endif

" Append s:gtest_var to g:ctrlp_ext_vars
if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
	let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:gtest_var)
else
	let g:ctrlp_ext_vars = [s:gtest_var]
endif


" This will be called by ctrlp to get the full list of elements
" where to look for matches
function! ctrlp#gtest#init()
  return gtest#GetAllTests()
endfunction


" This will be called by ctrlp when a match is selected by the user
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
func! ctrlp#gtest#accept(mode, str)
  call ctrlp#exit()
  redraw
  call gtest#GTestRunOnly(a:str)
endfunc


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
" Allow it to be called later
function! ctrlp#gtest#id()
  return s:id
endfunction

