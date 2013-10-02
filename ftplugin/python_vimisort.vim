command! Isort exec("py isort()")

python <<EOF
import vim
from isort import SortImports

def isort():
    old_contents = u'\n'.join(x.decode('utf-8') for x in vim.current.buffer[:])
    new_contents = SortImports(file_contents=old_contents).output
    vim.current.buffer[:] = new_contents.encode('utf-8').split('\n')
