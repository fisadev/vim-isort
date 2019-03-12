vim-isort
=========

Vim plugin to sort python imports using `isort <https://github.com/timothycrosley/isort>`_


Usage
=====

Just call the ``:Isort`` command, and it will reorder the imports of the current python file.
Or select a block of imports with visual mode, and press ``Ctrl-i`` to sort them.

You can also configure isort options, check them on the `isort docs <https://github.com/timothycrosley/isort>`_.


Installation
============

* Install `isort <https://github.com/timothycrosley/isort>`_:

.. code::

    pip install isort

* Add the plugin to vim using `Vundle <https://github.com/gmarik/vundle>`_ or any other plugin manager, pointing to this repo:

.. code::

    Plugin 'fisadev/vim-isort'

(Or if you don't use any plugin manager, you can just copy the ``python_vimisort.vim`` file to your ``.vim/ftplugin`` folder)

Configuration
=============

You can configure the default mapping for the visual mode sorter, like this:

.. code-block:: viml

    let g:vim_isort_map = '<C-i>'

Or disable the mapping with this:

.. code-block:: viml

    let g:vim_isort_map = ''

You can configure overrides for isort's config parameters:

.. code-block:: viml

    let g:vim_isort_config_overrides = {
      \ 'include_trailing_comma': 1, 'multi_line_output': 3}

You can also specify a particular Python version, so if `isort` is installed under Python 3:

.. code-block:: viml

    let g:vim_isort_python_version = 'python3'
