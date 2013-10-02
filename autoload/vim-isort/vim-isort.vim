" This will be called by the isort command
function! vim_isort#sort_imports()
python << endofpython
import vim
from isort import SortImports

old_contents = '\n'.join(vim.current.buffer[:])
new_contents = SortImports(file_contents=old_contents).output
vim.current.buffer[:] = new_contents.split('\n')
endofpython
endfunction

command! isort call vim_isort#sort_imports()
