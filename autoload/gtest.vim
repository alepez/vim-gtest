" ============================================================================
" File:        gtest.vim
" Description: Run google test inside vim
" Maintainer:  Alessandro Pezzato <http://pezzato.net/>
" License:     The MIT License (MIT)
" Version:     0.1.1
" ============================================================================

if !exists('g:gtest#gtest_command')
  let g:gtest#gtest_command = "make test"
endif

function! gtest#GTestRun()
  call VimuxRunCommand("( clear && " . g:gtest#gtest_command . ")")
endfunction
