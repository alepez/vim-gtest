fu! CreateRandomFile()
  return system('mktemp')[:-2]
endf

fu! s:StartListening()
  let g:gtest#stream_result = 1
  let s:results_file = CreateRandomFile()
  let l:cmd = "nc -l -p 2705 > " . s:results_file
  call system("tmux new-window -d '" . l:cmd . "'")
endf

fu! s:StopListening()
  " call system("rm " . s:results_file)
  let g:gtest#stream_result = 0
endf

fu! s:ReadLog()
  return readfile(s:results_file)
endf

fu! ParseEvent(event_str)
  let l:result = {}
  let l:tokens = split(a:event_str, '&')
  for l:token in l:tokens
    let l:spl = split(l:token, '=')
    let l:result[l:spl[0]] = l:spl[1]
  endfor
  return result
endf

fu! gtest#highlight#HighlightFailingTests()
  let l:lines = s:ReadLog()
  for l:line in l:lines
    if match(l:line, "^event=TestPartResult") != -1
      let l:event = ParseEvent(l:line)
      echom l:event["event"]
    endif
  endfor
endf

call s:StartListening()
call gtest#GTestRun()
