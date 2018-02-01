" Author: keith <k@keith.so>
" Description: pyflakes for python files

let g:ale_python_pyflakes_executable =
\   get(g:, 'ale_python_pyflakes_executable', 'pyflakes')

let g:ale_python_pyflakes_options =
\   get(g:, 'ale_python_pyflakes_options', '')

let g:ale_python_pyflakes_use_global = get(g:, 'ale_python_pyflakes_use_global', 0)

function! ale_linters#python#pyflakes#GetExecutable(buffer) abort
    if !ale#Var(a:buffer, 'python_pyflakes_use_global')
        let l:virtualenv = ale#python#FindVirtualenv(a:buffer)

        if !empty(l:virtualenv)
            let l:ve_pyflakes = l:virtualenv . '/bin/pyflakes'

            if executable(l:ve_pyflakes)
                return l:ve_pyflakes
            endif
        endif
    endif

    return ale#Var(a:buffer, 'python_pyflakes_executable')
endfunction

function! ale_linters#python#pyflakes#GetCommand(buffer) abort
    return fnameescape(ale_linters#python#pyflakes#GetExecutable(a:buffer))
    \   . ' ' . ale#Var(a:buffer, 'python_pyflakes_options')
    \   . ' %s'
endfunction

function! ale_linters#python#pyflakes#HandleOutput(buffer, lines) abort
    let l:pattern = '\v[a-zA-Z]+:(\d+): (.*)$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
        \   'lnum': l:match[1] + 0,
        \   'text':  l:match[2],
        \})
    endfor

    return l:output
endfunction

call ale#linter#Define('python', {
\   'name': 'pyflakes',
\   'executable_callback': 'ale_linters#python#pyflakes#GetExecutable',
\   'command_callback': 'ale_linters#python#pyflakes#GetCommand',
\   'callback': 'ale_linters#python#pyflakes#HandleOutput',
\   'lint_file': 1,
\})
