if exists('g:vim_isort_python_version')
    if g:vim_isort_python_version ==? 'python2'
        command! -nargs=1 AvailablePython python <args>
        let s:available_short_python = ':py'
    elseif g:vim_isort_python_version ==? 'python3'
        command! -nargs=1 AvailablePython python3 <args>
        let s:available_short_python = ':py3'
    endif
else
    if has('python3')
        command! -nargs=1 AvailablePython python3 <args>
        let s:available_short_python = ':py3'
    elseif has('python')
        command! -nargs=1 AvailablePython python <args>
        let s:available_short_python = ':py'
    else
        throw 'No python support present, vim-isort will be disabled'
    endif
endif

command! Isort exec("AvailablePython isort_file()")

if !exists('g:vim_isort_map')
    let g:vim_isort_map = '<C-i>'
endif

if g:vim_isort_map != ''
    execute "vnoremap <buffer>" g:vim_isort_map s:available_short_python "isort_visual()<CR>"
endif

if !exists('g:vim_isort_config_overrides')
    let g:vim_isort_config_overrides = {}
endif

AvailablePython <<EOF
from __future__ import print_function
import vim
from sys import version_info

try:
    from isort import SortImports
    isort_imported = True
except ImportError:
    isort_imported = False


# in python2, the vim module uses utf-8 encoded strings
# in python3, it uses unicodes
# so we have to do different things in each case
using_bytes = version_info[0] == 2


def count_blank_lines_at_end(lines):
    blank_lines = 0
    for line in reversed(lines):
        if line.strip():
            break
        else:
            blank_lines += 1
    return blank_lines


def isort(text_range):
    if not isort_imported:
        print("No isort python module detected, you should install it. More info at https://github.com/fisadev/vim-isort")
        return

    config_overrides = vim.eval('g:vim_isort_config_overrides')
    if not isinstance(config_overrides, dict):
        print('g:vim_isort_config_overrides should be dict, found {}'.format(type(config_overrides)))
        return
    # convert ints carried over from vim as strings
    config_overrides = {k: int(v) if isinstance(v, str) and v.isdigit() else v
                        for k, v in config_overrides.items()}

    blank_lines_at_end = count_blank_lines_at_end(text_range)

    old_text = '\n'.join(text_range)
    if using_bytes:
        old_text = old_text.decode('utf-8')

    new_text = SortImports(file_contents=old_text, **config_overrides).output

    if new_text is None or old_text == new_text:
        return

    if using_bytes:
        new_text = new_text.encode('utf-8')

    new_lines = new_text.split('\n')

    # remove empty lines wrongfully added
    while new_lines and not new_lines[-1].strip() and blank_lines_at_end < count_blank_lines_at_end(new_lines):
        del new_lines[-1]

    text_range[:] = new_lines

def isort_file():
    isort(vim.current.buffer)

def isort_visual():
    isort(vim.current.range)

EOF
