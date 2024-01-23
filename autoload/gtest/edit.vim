fu! s:GetFixtureNameFromLine(line)
  retur substitute(a:line, '^\(struct\|class\) \+\(\w\+\).*$', '\2', '')
endf

fu! s:GetPrevFixtureName()
  silent normal! ?testing::Test
  let l:fixture_name = s:GetFixtureNameFromLine(getline('.'))
  normal ``
  return l:fixture_name
endf

fu! g:gtest#edit#InsertNewTest()
  let l:fixture = s:GetPrevFixtureName()
  let l:new_test = 'TEST_F(' . l:fixture . ', __TESTNAME__){}'
  exe ':normal i' . l:new_test
  silent normal! ?__TESTNAME__dw
endf
