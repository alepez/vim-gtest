" ============================================================================
" Maintainer:  Alessandro Pezzato <http://pezzato.net/>
" License:     The MIT License (MIT)
" ============================================================================

fu! s:GetBasename(path)
  let l:res = fnamemodify(a:path, ':r')
  let l:res = substitute(l:res, "^\[^/\]*/", "", "")
  return substitute(l:res, "_test$", "", "")
endf

fun! s:GetTestPath(path)
  let l:base = s:GetBasename(a:path)
  return "test/" . l:base . "_test.cpp"
endf

fun! s:GetHeaderPath(path)
  let l:base = s:GetBasename(a:path)
  return "src/" . l:base . ".hpp"
endf

fun! s:GetImplementationPath(path)
  let l:base = s:GetBasename(a:path)
  return "src/" . l:base . ".cpp"
endf

fu! s:GetFileType(path)
  if match(a:path, "_test.cpp$") != -1
    return 1
  elseif match(a:path, ".cpp$") != -1
    return 2
  elseif match(a:path, ".hpp$") != -1
    return 3
  endif
endf

" Switch between files:
"
" src/<name>.cpp
" src/<name>.hpp
" test/<name>_test.cpp
"
fu! gtest#jump#FileJump()
  let l:path = expand("%")
  let l:n = s:GetFileType(l:path)
  if l:n == 1
    let l:path = s:GetImplementationPath(l:path)
  elseif l:n == 2
    let l:path = s:GetHeaderPath(l:path)
  elseif l:n == 3
    let l:path = s:GetTestPath(l:path)
  endif
  silent! execute ":e " . l:path
endf
