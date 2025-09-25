if exists('g:vim_isort_python_version')
    if g:vim_isort_python_version ==? 'python2'
        command! -nargs=1 AvailablePython python <args>
        let s:available_short_python = 'py'
    elseif g:vim_isort_python_version ==? 'python3'
        command! -nargs=1 AvailablePython python3 <args>
        let s:available_short_python = 'py3'
    endif
else
    if has('python3')
        command! -nargs=1 AvailablePython python3 <args>
        let s:available_short_python = 'py3'
    elseif has('python')
        command! -nargs=1 AvailablePython python <args>
        let s:available_short_python = 'py'
    else
        throw 'No python support present, vim-isort will be disabled'
    endif
endif

command! Isort exec("call vimisort#init()|AvailablePython isort_file()")

if !exists('g:vim_isort_map')
    let g:vim_isort_map = '<C-i>'
endif

if g:vim_isort_map != ''
    " execute "vnoremap <buffer> " . g:vim_isort_map . " :call vimisort#init()<Cr>gv:" . s:available_short_python . " isort_visual()<CR>"
    execute "vnoremap <buffer> " . g:vim_isort_map . " <Cmd>call vimisort#init()<Cr>:" . s:available_short_python . " isort_visual()<CR>"
endif

if !exists('g:vim_isort_config_overrides')
    let g:vim_isort_config_overrides = {}
endif
