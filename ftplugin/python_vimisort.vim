command! Isort exec("py isort_file()")

if has('python')
    command! -nargs=1 AvailablePython python <args>
elseif has('python3')
    command! -nargs=1 AvailablePython python3 <args>
else
    echo "No python interpreter available, vim-isort won't work"
endif

if !exists('g:vim_isort_map')
    let g:vim_isort_map = '<C-i>'
endif

if g:vim_isort_map != '' && has('AvailablePython')
    execute "vnoremap <buffer>" g:vim_isort_map  ":AvailablePython isort_visual()<CR>"
endif

AvailablePython <<EOF
import vim
from sys import version_info
from isort import SortImports

# in python2, the vim module uses utf-8 encoded strings
# in python3, it uses unicodes
# so we have to do different things in each case
using_bytes = version_info.major == 2

def isort(text_range):
    old_text = '\n'.join(text_range)
    if using_bytes:
        old_text = old_text.decode('utf-8')

    new_text = SortImports(file_contents=old_text).output

    if using_bytes:
        new_text = new_text.encode('utf-8')

    new_lines = new_text.split('\n')

    # remove new line added because of the split('\n')
    if not new_lines[-1].strip():
        del new_lines[-1]

    text_range[:] = new_lines

def isort_file():
    isort(vim.current.buffer)

def isort_visual():
    isort(vim.current.range)

EOF
