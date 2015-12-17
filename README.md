# vim-gtest

**Vim plugin to run *GoogleTest* using https://github.com/benmills/vimux**

<img src="http://files.pezzato.net/github/vim-gtest.gif" />

### Select gtest command

```
:GTestCmd path/to/test/executable
```

### Select tests by name

You can select test cases and test name, with autocompletion.

```
:GTestCase MyTestCase
:GTestName MyTestName
```

### Run tests

```
:GTestRun
```

### Find tests

Go to the next test in the current buffer.

```
:GTestNext
```

## Shortcuts

You can map these commands to your favorite shortcut:

```
nnoremap <leader>tt :GTestRun<CR>
nnoremap <leader>tc :GTestCase<space>
nnoremap <leader>tn :GTestName<space>
```
