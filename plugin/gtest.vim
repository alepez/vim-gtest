" gtest.vim - Run google test inside vim
" Maintainer:   Alessandro Pezzato <http://pezzato.net/>
" Version:      0.1

" Initialization {{{1
if !exists('g:gtest_debug') && exists("g:loaded_gtest") || &cp
  finish
endif
let g:loaded_gtest = 1

" }}}1

command! -nargs=0 GTestRun call GTestRun()

function! GTestRun()
    call VimuxRunCommand("( clear && make test )")
endfunction

" vim:set ft=vim sw=2 sts=2:
