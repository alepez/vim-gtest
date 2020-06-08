let s:old_cpo = &cpo
set cpo&vim

if !exists(':FZF')
    finish
endif

command! -bang -nargs=* FZFGTest call fzf#gtest#SelectTest(<q-args>, <bang>0)

let &cpo = s:old_cpo
unlet s:old_cpo

