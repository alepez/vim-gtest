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
function! s:GetFilters()
  return "--gtest_filter='" . g:gtest#test_case . "." . g:gtest#test_name . "'"
endfunction

function! s:GetArguments()
  return s:GetFilters()
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
" }}}
