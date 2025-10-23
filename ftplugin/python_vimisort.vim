" Prevent multiple executions
if exists('b:did_vim_isort_ftplugin')
    finish
endif
let b:did_vim_isort_ftplugin = 1

" Initialize config overrides if not already set
if !exists('g:vim_isort_config_overrides')
    let g:vim_isort_config_overrides = {}
endif

" Determine Python executable
if exists('g:vim_isort_python_version')
    if g:vim_isort_python_version =~ '[/\\]'
        if !executable(g:vim_isort_python_version)
            throw 'Python executable not found at: ' . g:vim_isort_python_version
        endif
        let g:vim_isort_use_external_python = 1
        let g:vim_isort_python_path = g:vim_isort_python_version
    elseif g:vim_isort_python_version ==? 'python2'
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
        throw 'No Python support present, vim-isort will be disabled'
    endif
endif

" Define external isort function if needed
if exists('g:vim_isort_use_external_python') && g:vim_isort_use_external_python
    if !exists(':Isort')
        command! Isort call s:IsortViaSystem()
    endif

    if !exists('*s:IsortViaSystem')
        function! s:IsortViaSystem()
            let l:file = expand('%:p')
            if empty(l:file)
                echoerr 'No file to sort'
                return
            endif

            " Save view and write file
            let l:view = winsaveview()
            write

            " Build config arguments
            let l:config_args = ''
            for [l:key, l:value] in items(g:vim_isort_config_overrides)
                let l:config_args .= ' --' . substitute(l:key, '_', '-', 'g') . '=' . shellescape(l:value)
            endfor

            " Run isort
            let l:cmd = shellescape(g:vim_isort_python_path) . ' -m isort ' . l:config_args . ' ' . shellescape(l:file)
            let l:output = system(l:cmd)

            if v:shell_error != 0
                echoerr 'isort failed: ' . l:output
            else
                " Reload file and restore view safely
                silent! edit!
                call winrestview(l:view)
            endif
        endfunction
    endif
else
    if !exists(':Isort')
        command! Isort exec("call vimisort#init()|AvailablePython isort_file()")
    endif
endif

" Default key mapping
if !exists('g:vim_isort_map')
    let g:vim_isort_map = '<C-i>'
endif

" Apply key mappings
if g:vim_isort_map != ''
    if exists('g:vim_isort_use_external_python') && g:vim_isort_use_external_python
        execute "nnoremap <buffer> " . g:vim_isort_map . " :Isort<CR>"
        execute "vnoremap <buffer> " . g:vim_isort_map . " :Isort<CR>"
    else
        execute "nnoremap <buffer> " . g:vim_isort_map . " <Cmd>call vimisort#init()<CR>:" . s:available_short_python . " isort_file()<CR>"
        execute "vnoremap <buffer> " . g:vim_isort_map . " <Cmd>call vimisort#init()<CR>:" . s:available_short_python . " isort_visual()<CR>"
    endif
endif
