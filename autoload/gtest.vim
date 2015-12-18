" ============================================================================
" File:        gtest.vim
" Description: Run google test inside vim
" Maintainer:  Alessandro Pezzato <http://pezzato.net/>
" License:     The MIT License (MIT)
" Version:     0.1.2
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

function! s:GetTestCaseFromFull(full)
  return split(a:full, '\.')[0]
endfunction

function! s:GetTestNameFromFull(full)
  return split(a:full, '\.')[1]
endfunction

function! s:GetTestFullFromLine(line)
  return substitute(a:line, '^TEST.*(\(.*\), *\(.*\)).*$', '\1.\2', '')
endfunction

function! gtest#ListTestCases(A, L, P)
  " FIXME naive implementation with system and sed. Use vim builtin instead
  return system(g:gtest#gtest_command . " --gtest_list_tests | sed '/^ /d' | sed 's/\.$//' | sed '/main\(\)/d'")
endfunction

function! gtest#ListTestNames(A, L, P)
  " FIXME naive implementation with system and sed. Use vim builtin instead
  return system(g:gtest#gtest_command . " --gtest_filter='" . g:gtest#test_case . ".*' --gtest_list_tests | sed '/^[^ ]/d' | sed 's/^  //'")
endfunction

fu! s:ListTests()
  return system(g:gtest#gtest_command . " --gtest_list_tests")
endf

fu! s:ParseTests(tests)
  " split to lines, remove the first line
  let l:lines = split(a:tests, '\n')[1:]
  let l:result = []
  for l:line in l:lines
    if l:line[0] != ' '
      " Lines not starting with space are test cases
      let l:test_case = l:line
      " Add a special * for each case (all tests in that test case)
      call add(l:result, l:test_case . "*")
    else
      " Lines starting with space are tests
      call add(l:result, l:test_case . l:line[2:])
    endif
  endfor

  return result
endf

fu! s:SelectTestByFullName(full)
  call gtest#GTestCase(s:GetTestCaseFromFull(a:full))
  call gtest#GTestName(s:GetTestNameFromFull(a:full))
endf

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

" Find prev test in buffer
function! gtest#GTestPrev()
  silent normal! ?^TEST
endfunction

" Find next test in buffer
function! gtest#GTestNext()
  silent normal! /^TEST
endfunction

" Get the list of all tests, [ 'Case1.Test1', 'Case1.Test2', 'Case2.Test1' ...]
fu! gtest#GetAllTests()
  return s:ParseTests(s:ListTests())
endf

" Select test under cursor
function! gtest#GTestUnderCursor(try_prev)
  let l:full = s:GetTestFullFromLine(getline("."))
  try
    call s:SelectTestByFullName(l:full)
  catch
    if a:try_prev
      " Find test line
      call gtest#GTestPrev()
      call gtest#GTestUnderCursor(0)
      " Go back to position
      normal! ``
    endif
  endtry
endfunction

" Select and run test by full test name
function! gtest#GTestRunOnly(full)
  call s:SelectTestByFullName(a:full)
  call gtest#GTestRun()
endfunction

" Select and run test under cursor
function! gtest#GTestRunUnderCursor()
  call gtest#GTestUnderCursor(1)
  call gtest#GTestRun()
endfunction
" }}}

