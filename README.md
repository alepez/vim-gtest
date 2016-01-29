# vim-gtest

**Vim plugin to quickly select and run
[*GoogleTest*](https://github.com/google/googletest) asyncronously.**

<p align="center"><img src="http://pezzato.net/2015/12/20/vim-gtest.gif" /></p>

## Usage

### Select gtest command

```
:GTestCmd path/to/test/executable
```

Or add this line to your `.vimrc`:

```
let g:gtest#gtest_command = "path/to/test/executable"
```

Default is: ./test

### Select tests by name

You can select test case and test name, with autocompletion.

```
:GTestCase MyTestCase
:GTestName MyTestName
```

### Run selected tests

```
:GTestRun
```

### Find tests

Go to the prev/next test in the current buffer.

```
:GTestPrev
:GTestNext
```

### Enable/Disable tests under cursor

This remove/add `DISABLED_` prefix to test name.

```
:GTestToggleEnabled
```


### Run test under cursor

```
:GTestRunUnderCursor
```

### CtrlP

Don't you know what [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim) is?

It's a fantastic fuzzy finder for vim! Try it immediately!

`vim-gtest` extends *ctrlp.vim* with a google test finder. Now you can find
and launch tests at the speed of light!

**Attention:** [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim) must be installed.

### QuickFix

You can tell `vim-gtest` to highlight failing tests using vim's *QuickFix*.

```
:let g:gtest#highlight_failing_tests = 1
:GTestRun
:GTestHighlight
```

If you have [vim-dispatch](https://github.com/tpope/vim-dispatch) installed,
calling `:GTestHighlight` isn't needed.

### Switch files

You can switch from implementation to header to test:

```
:GTestJump
```

Filenames must follow this rule:

 - implementation: `src/**/*.cpp`
 - header: `src/**/*.hpp`
 - test: `test/**/*_test.cpp`

## Shortcuts

You can map these commands to your favorite shortcuts. These are mine:

```
augroup GTest
	autocmd FileType cpp nnoremap <silent> <leader>tt :GTestRun<CR>
	autocmd FileType cpp nnoremap <silent> <leader>tu :GTestRunUnderCursor<CR>
	autocmd FileType cpp nnoremap          <leader>tc :GTestCase<space>
	autocmd FileType cpp nnoremap          <leader>tn :GTestName<space>
	autocmd FileType cpp nnoremap <silent> <leader>te :GTestToggleEnabled<CR>
	autocmd FileType cpp nnoremap <silent> ]T         :GTestNext<CR>
	autocmd FileType cpp nnoremap <silent> [T         :GTestPrev<CR>
	autocmd FileType cpp nnoremap <silent> <leader>tf :CtrlPGTest<CR>
	autocmd FileType cpp nnoremap <silent> <leader>tj :GTestJump<CR>
augroup END
```

## Development

### Contributing

If you'd like to help, check out the
[issues](https://github.com/alepez/vim-gtest/issues). I'd greatly appreciate
any contribution you make. Beer is also appreciated ☺

### Testing

To test this plugin you need to test it with a testable project. `googletest`
can test itself. Testception ☺.

This will download and compile google test and its unit tests:

```
./test/make_test
```

Now from `vim`, just call from command line `:GTestCmd ./test/launch`.

After editing this plugin, just `:source %` and try something. Samples unit
tests can be found in `test/googletest/googletest/samples` directory.

## Thanks

Thanks to the creator of https://github.com/ctrlpvim/ctrlp.vim

Thanks to the creator of https://github.com/fisadev/vim-ctrlp-cmdpalette,
which allowed me to learn how to extend CtrlP.

Special thanks to [Tim Pope](https://github.com/tpope), the author of
[vim-dispatch](https://github.com/tpope/vim-dispatch) and many other useful
plugins.

## Self-Promotion

Like vim-gtest?  Follow the repository on
[GitHub](https://github.com/alepez/vim-gtest) and vote for it on
[vim.org](http://www.vim.org/scripts/script.php?script_id=5292). And if you're
feeling especially charitable, follow [Alessandro Pezzato](http://pezzato.net/)
on [Twitter](http://twitter.com/alepezzato) and
[GitHub](https://github.com/alepez).

