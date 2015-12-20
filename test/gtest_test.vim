source autoload/gtest.vim
source plugin/gtest.vim

GTestCmd "./test/googletest/googletest/make/sample1_unittest"

" Add test here
let s:file = "../samples/sample1_unittest.cc"
let s:dir = fnamemodify(g:gtest#gtest_command, ':h')
let s:file = resolve(s:dir . "/" . s:file)
