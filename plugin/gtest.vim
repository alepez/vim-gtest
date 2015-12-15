" ============================================================================
" File:        gtest.vim
" Description: Run google test inside vim
" Maintainer:  Alessandro Pezzato <http://pezzato.net/>
" License:     The MIT License (MIT)
" Version:     0.1.1
" ============================================================================

" Init {{{
if !exists('g:gtest_debug') && exists("g:loaded_gtest") || &cp
  finish
endif
let g:loaded_gtest = 1
" }}}

" Commands {{{
command! -nargs=0 GTestRun call gtest#GTestRun()
" }}}

" vim:set ft=vim sw=2 sts=2: