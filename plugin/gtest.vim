" ============================================================================
" File:        gtest.vim
" Description: Run google test inside vim
" Maintainer:  Alessandro Pezzato <http://pezzato.net/>
" License:     The MIT License (MIT)
" Version:     1.1.0
" ============================================================================

" Init {{{
if !exists('g:gtest_debug') && exists("g:loaded_gtest") || &cp
  finish
endif
let g:loaded_gtest = 1
" }}}

" Commands {{{
command! -nargs=0 GTestNext call gtest#GTestNext()
command! -nargs=0 GTestPrev call gtest#GTestPrev()
command! -nargs=0 GTestRun call gtest#GTestRun()
command! -nargs=0 GTestToggleEnabled call gtest#GTestToggleEnabled()
command! -nargs=0 GTestUnderCursor call gtest#GTestUnderCursor(1)
command! -nargs=0 GTestRunUnderCursor call gtest#GTestRunUnderCursor()
command! -nargs=0 GTestHighlight call gtest#highlight#HighlightFailingTests()
command! -nargs=0 GTestJump call gtest#jump#FileJump()
command! -nargs=0 GTestNewTest call gtest#edit#InsertNewTest()
command! -nargs=1 -complete=custom,gtest#ListTestCases GTestCase call gtest#GTestCase(<f-args>)
command! -nargs=1 -complete=custom,gtest#ListTestNames GTestName call gtest#GTestName(<f-args>)
command! -nargs=1 -complete=file GTestCmd call gtest#GTestCmd(<f-args>)
" }}}

" vim:set ft=vim sw=2 sts=2:
