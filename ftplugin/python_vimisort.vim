command! Isort exec("py isort_file()")

if !exists('g:vim_isort_map')
    let g:vim_isort_map = '<C-i>'
endif

if g:vim_isort_map != ''
    execute "vnoremap <buffer>" g:vim_isort_map  ":py isort_visual()<CR>"
endif

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

def isort(text_range):
    old_contents = u'\n'.join(x.decode('utf-8') for x in text_range[:])
    new_contents = SortImports(file_contents=old_contents).output
    text_range[:] = new_contents.encode('utf-8').split('\n')

def isort_file():
    isort(vim.current.buffer)

def isort_visual():
    isort(vim.current.range)

EOF
