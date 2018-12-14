if exists("loaded_fzf_gtest")
  finish
endif
let loaded_fzf_gtest = 1

function! fzf#gtest#SelectTest(...)
    if exists(':FZF')
        return fzf#run({
                    \ 'source': gtest#GetAllTests(),
                    \ 'options': '+m -n 1 --prompt GTest\>\ ',
                    \ 'down':    '30%',
                    \ 'sink':    function('gtest#GTestRunOnly')})
    endif
endfunction


