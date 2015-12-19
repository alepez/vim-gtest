fu! CreateRandomFile()
  return system('mktemp')
endf

let s:results_file = CreateRandomFile()

fu! s:StartListening()
  let l:cmd = "nc -l -p 2705 > " . s:results_file
  call system("tmux new-window -d '" . l:cmd . "'")
endf

call s:StartListening()
