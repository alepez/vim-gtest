" ============================================================================
" Maintainer:  Alessandro Pezzato <http://pezzato.net/>
" License:     The MIT License (MIT)
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

" Needed for failing test highlight
if !exists('g:gtest#highlight_failing_tests')
  let g:gtest#highlight_failing_tests = 0
endif
" }}}

" Private functions {{{
function! s:GetMiscArguments()
  let l:args = ""

  if g:gtest#highlight_failing_tests && !exists(':Dispatch')
    let l:args = l:args . " --gtest_stream_result_to=localhost:2705"
  endif

  let l:args = l:args . " --gtest_print_time=0"

  return l:args
endfunction

function! s:GetFilters()
  return "--gtest_filter='" . g:gtest#test_case . "." . g:gtest#test_name . "'"
endfunction

function! s:GetArguments()
  return s:GetMiscArguments() . " " .s:GetFilters()
endfunction

function! s:GetFullCommand()
  let l:cmd = g:gtest#gtest_command . " " . s:GetArguments()
  return "( clear && " . l:cmd . ")"
endfunction

function! s:GetTestCaseFromFull(full)
  return split(a:full, '\.')[0]
endfunction

function! s:GetTestNameFromFull(full)
  return split(a:full, '\.')[1]
endfunction

function! s:GetTestFullFromLine(line)
  let l:result = substitute(a:line, '^TEST\s*(\s*\(\S\{-1,}\),\s*\(\S\{-1,}\)\s*).*$', '\1.\2', '')
  return l:result 
endfunction

function! gtest#ListTestCases(arg, line, pos)
  let l:all = s:ParseTestCases(s:ListTests())
  return join(l:all, "\n")
endfunction

function! gtest#ListTestNames(arg, line, pos)
  let l:all = s:ParseTestNames(s:ListTests())
  return join(l:all, "\n")
endfunction

fu! s:ListTests()
  return system(g:gtest#gtest_command . " --gtest_list_tests")
endf

fu! s:ParseTestCases(tests)
  " split to lines, remove the first line
  let l:lines = split(a:tests, '\n')[1:]
  " Result is a list
  let l:result = []
  " Add special * case
  call add(l:result, "*")
  for l:line in l:lines
    if l:line[0] != ' '
      call add(l:result, l:line[:-2])
    endif
  endfor
  return result
endf

fu! s:ParseTestNames(tests)
  " split to lines, remove the first line
  let l:lines = split(a:tests, '\n')[1:]
  " Result is a list
  let l:result = []
  " Add special * test
  call add(l:result, "*")
  " Needed to filter by test case
  let l:test_case = ""

  for l:line in l:lines
    if l:line[0] != ' '
      " Lines not starting with space are test cases, set current case
      let l:test_case = l:line[:-2]
    else
      " Lines starting with space are tests
      if l:test_case == g:gtest#test_case
        call add(l:result, l:line[2:])
      endif
    endif
  endfor

  return result
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

fu! s:RunWithMake(wrapper, cmd, highlight_errors)
  " remember current makeprg and errorformat
  let l:makeprg=&makeprg
  let l:errorformat=&errorformat

  if exists('g:neomake_open_list')
    let l:neomake_open_list=g:neomake_open_list
  endif

  " temporary set makeprg
  let &makeprg=a:cmd

  " tell neomake to open quickfix
  let g:neomake_open_list=2

  " this is how gtest outputs errors
  if (a:highlight_errors)
    set errorformat=%f:%l:\ %m
  else
    set errorformat=pleasedonotmatchanything " hacky, but working
  endif

  " call Make or Neomake
  silent execute a:wrapper

  " restore previous makeprg and errorformat
  let &makeprg=l:makeprg
  let &errorformat=l:errorformat

  if exists('l:neomake_open_list')
    let g:neomake_open_list=l:neomake_open_list
  endif
endf

" }}}

" Public functions {{{

" Run selected executable with filters, inside a tmux pane
function! gtest#GTestRun()
  let l:cmd = s:GetFullCommand()

  " Try with neomake
  if exists(':Neomake')
    call s:RunWithMake('Neomake!', l:cmd, g:gtest#highlight_failing_tests)
  " Try with vim-dispatch
  elseif exists(':Dispatch')
    call s:RunWithMake('Make', l:cmd, g:gtest#highlight_failing_tests)
  " Try with VimuxRunCommand
  elseif exists('VimuxRunCommand')
    if g:gtest#highlight_failing_tests
      call gtest#highlight#StartListening()
    endif

    call VimuxRunCommand(l:cmd)
  else
    if g:gtest#highlight_failing_tests
      call gtest#highlight#StartListening()
    endif

    " Fallback to syncronous system command
    execute '!' . l:cmd
  endif

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

fu! s:LineIsTestEnabled(line)
  return -1 == match(a:line, "DISABLED_")
endf

fu! s:LineIsTestHeader(line)
  return 0 == match(a:line, "^TEST")
endf

" Get the list of all tests, [ 'Case1.Test1', 'Case1.Test2', 'Case2.Test1' ...]
fu! gtest#GetAllTests()
  return ["*.*"] + s:ParseTests(s:ListTests())
endf

" Select test under cursor
function! gtest#GTestUnderCursor(try_prev)
  try
    let l:line = getline(".")

    if !(s:LineIsTestHeader(l:line))
      throw "This line is not a test"
    endif

    let l:full = s:GetTestFullFromLine(l:line)
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

fu! gtest#GTestToggleEnabled()
  let l:line = getline(".")
  let l:position_changed = 0
  if !(s:LineIsTestHeader(l:line))
    let l:position_changed = 1
    call gtest#GTestPrev()
    let l:line = getline(".")
  endif
  if s:LineIsTestEnabled(l:line)
    silent normal! 0f aDISABLED_
  else
    silent normal! 0/DISABLED_df_
  endif
  if l:position_changed
    normal! ``
  endif
endf
" }}}

" vim:foldmethod=marker:foldlevel=1
