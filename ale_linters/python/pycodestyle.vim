" Author: keith <k@keith.so>
" Description: pycodestyle for python files

let g:ale_python_pycodestyle_executable =
\   get(g:, 'ale_python_pycodestyle_executable', 'pycodestyle')

let g:ale_python_pycodestyle_options =
\   get(g:, 'ale_python_pycodestyle_options', '')

let g:ale_python_pycodestyle_use_global = get(g:, 'ale_python_pycodestyle_use_global', 0)

function! ale_linters#python#pycodestyle#GetExecutable(buffer) abort
    if !ale#Var(a:buffer, 'python_pycodestyle_use_global')
        let l:virtualenv = ale#python#FindVirtualenv(a:buffer)

        if !empty(l:virtualenv)
            let l:ve_pycodestyle = l:virtualenv . '/bin/pycodestyle'

            if executable(l:ve_pycodestyle)
                return l:ve_pycodestyle
            endif
        endif
    endif

    return ale#Var(a:buffer, 'python_pycodestyle_executable')
endfunction

function! ale_linters#python#pycodestyle#GetCommand(buffer) abort
    return fnameescape(ale_linters#python#pycodestyle#GetExecutable(a:buffer))
    \   . ' ' . ale#Var(a:buffer, 'python_pycodestyle_options')
    \   . ' %s'
endfunction

call ale#linter#Define('python', {
\   'name': 'pycodestyle',
\   'executable_callback': 'ale_linters#python#pycodestyle#GetExecutable',
\   'command_callback': 'ale_linters#python#pycodestyle#GetCommand',
\   'callback': 'ale#handlers#python#HandlePEP8Format',
\   'lint_file': 1,
\})
