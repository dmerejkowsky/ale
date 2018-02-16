" Author: dmerej
" Description: pychecksyntax (from dmerej's dotfiles) for python files

function! ale_linters#python#pychecksyntax#GetExecutable(buffer) abort
    return 'pychecksyntax'
endfunction

function! ale_linters#python#pychecksyntax#GetCommand(buffer) abort
    return 'pychecksyntax' . ' %s'
endfunction

function! ale_linters#python#pychecksyntax#HandleOutput(buffer, lines) abort
    let l:pattern = '\v[a-zA-Z]+:(\d+):(\d+): (.*)$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        echom join(l:match, "\n")
        call add(l:output, {
        \   'lnum': l:match[1] + 0,
        \   'col': l:match[2] + 0,
        \   'text':  l:match[3],
        \})
    endfor

    return l:output
endfunction

call ale#linter#Define('python', {
\   'name': 'pychecksyntax',
\   'executable_callback': 'ale_linters#python#pychecksyntax#GetExecutable',
\   'command_callback': 'ale_linters#python#pychecksyntax#GetCommand',
\   'callback': 'ale_linters#python#pychecksyntax#HandleOutput',
\   'lint_file': 1,
\})
