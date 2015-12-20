fu! CreateRandomFile()
  return system('mktemp')
endf

fu! s:StartListening()
  let s:results_file = CreateRandomFile()
  let l:cmd = "nc -l -p 2705 > " . s:results_file
  call system("tmux new-window -d '" . l:cmd . "'")
endf

fu! s:StopListening()
  call system("rm " . s:results_file)
endf

fu! s:ReadLog()
  l:lines = readfile(s:results_file)
  return l:lines
endf

fu! gtest#highlight#HighlightFailingTests()
  call s:ReadLog()
endf

call s:StartListening()

