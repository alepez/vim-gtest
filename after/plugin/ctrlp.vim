" ============================================================================
" Maintainer:  Alessandro Pezzato <http://pezzato.net/>
" License:     The MIT License (MIT)
" ============================================================================

" Check if CtrlP is loaded.
if !exists('g:loaded_ctrlp') || !g:loaded_ctrlp
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" Register the command which open CtrlP with GoogleTest search
command! CtrlPGTest call ctrlp#init(ctrlp#gtest#id())

let &cpo = s:save_cpo
unlet s:save_cpo
