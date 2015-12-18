" ============================================================================
" File:        gtest.vim
" Description: Run google test inside vim
" Maintainer:  Alessandro Pezzato <http://pezzato.net/>
" License:     The MIT License (MIT)
" Version:     0.1.1
" ============================================================================

" Options {{{
" Test case selector, used by --gtest_filter='TestCase.TestName'
if !exists('g:gtest#test_case')
  let g:gtest#test_case = "*"
endif

" Test name selector, used by --gtest_filter='TestCase.TestName'
if !exists('g:gtest#test_name')
  let g:gtest#test_name = "*"
endif

" Test executable, absolute path or relative to pwd
if !exists('g:gtest#gtest_command')
  let g:gtest#gtest_command = "./test"
endif
" }}}

" Private functions {{{
function! s:GetMiscArguments()
  return "--gtest_print_time=0"
endfunction

function! s:GetFilters()
  return "--gtest_filter='" . g:gtest#test_case . "." . g:gtest#test_name . "'"
endfunction

function! s:GetArguments()
  return s:GetMiscArguments() . " " .s:GetFilters()
endfunction

function! s:GetFullCommand()
  let l:cmd = g:gtest#gtest_command . " " . s:GetArguments()
  echom l:cmd
  return "( clear && " . l:cmd . ")"
endfunction

function! gtest#ListTestCases(A, L, P)
  " FIXME naive implementation with system and sed. Use vim builtin instead
  return system(g:gtest#gtest_command . " --gtest_list_tests | sed '/^ /d' | sed 's/\.$//' | sed '/main\(\)/d'")
endfunction

function! gtest#ListTestNames(A, L, P)
  " FIXME naive implementation with system and sed. Use vim builtin instead
  return system(g:gtest#gtest_command . " --gtest_filter='" . g:gtest#test_case . ".*' --gtest_list_tests | sed '/^[^ ]/d' | sed 's/^  //'")
endfunction
" }}}

" Public functions {{{

" Run selected executable with filters, inside a tmux pane
function! gtest#GTestRun()
  call VimuxRunCommand(s:GetFullCommand())
endfunction

" Set test executable
function! gtest#GTestCmd(gtest_command)
  let g:gtest#gtest_command = a:gtest_command
endfunction

" Set test case
function! gtest#GTestCase(test_case)
  let g:gtest#test_case = a:test_case
endfunction

" Set test name
function! gtest#GTestName(test_name)
  let g:gtest#test_name = a:test_name
endfunction

" Find prev test in buffer and go to first line in the block
function! gtest#GTestPrev()
  normal! 2k?^TESTj^
endfunction

" Find next test in buffer and go to first line in the block
function! gtest#GTestNext()
  normal! /^TESTj^
endfunction
" }}}
