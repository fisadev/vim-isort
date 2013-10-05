command! Isort exec("py isort()")

python <<EOF
import vim
try:
    from isort import SortImports
except ImportError:
    import sys
    for p in ['isort', 'pies', 'natsort']:
        sys.path.append(
            vim.eval('expand("<sfile>:h:h") . "/python/{0}"'.format(p)))
    from isort import SortImports

def isort():
    old_contents = u'\n'.join(x.decode('utf-8') for x in vim.current.buffer[:])
    new_contents = SortImports(file_contents=old_contents).output
    vim.current.buffer[:] = new_contents.encode('utf-8').split('\n')
