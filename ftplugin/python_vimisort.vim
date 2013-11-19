command! Isort exec("py isort()")
autocmd FileType python vnoremap <C-i> :python isort_visual(vim.current.range)<CR>

python <<EOF
import vim
from isort import SortImports

def isort():
    old_contents = u'\n'.join(x.decode('utf-8') for x in vim.current.buffer[:])
    new_contents = SortImports(file_contents=old_contents).output
    vim.current.buffer[:] = new_contents.encode('utf-8').split('\n')

def isort_visual(current_range):
    old_contents = u'\n'.join(x.decode('utf-8') for x in current_range)
    new_contents = SortImports(file_contents=old_contents).output
    vim.current.range[:] = new_contents.encode('utf-8').split('\n')

EOF
