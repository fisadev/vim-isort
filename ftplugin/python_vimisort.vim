" This will be called by the isort command
function! s:Isort()
python << endofpython
import vim
from isort import SortImports

old_contents = '\n'.join(vim.current.buffer[:])
new_contents = SortImports(file_contents=old_contents).output
vim.current.buffer[:] = new_contents.split('\n')
endofpython
endfunction

command! Isort call s:Isort()
