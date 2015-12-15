" ============================================================================
" File:        gtest.vim
" Description: Run google test inside vim
" Maintainer:  Alessandro Pezzato <http://pezzato.net/>
" License:     The MIT License (MIT)
" Version:     0.1.1
" ============================================================================

" Options {{{
if !exists('g:gtest#test_case')
  let g:gtest#test_case = "*"
endif

if !exists('g:gtest#test_name')
  let g:gtest#test_name = "*"
endif

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
" }}}

" Public functions {{{
function! gtest#GTestRun()
  call VimuxRunCommand(s:GetFullCommand())
endfunction

function! gtest#GTestCmd(gtest_command)
  let g:gtest#gtest_command = a:gtest_command
endfunction

function! gtest#GTestCase(test_case)
  let g:gtest#test_case = a:test_case
endfunction

function! gtest#GTestName(test_name)
  let g:gtest#test_name = a:test_name
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
