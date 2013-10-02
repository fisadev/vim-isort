vim-isort
=========

Vim plugin to sort python imports using `isort <https://github.com/timothycrosley/isort>`_


Usage
=====

Just call the ``:Isort`` command, and it will reorder the imports of the current python file.

You can also configure isort options, check them on the `isort docs <https://github.com/timothycrosley/isort>`_.


Installation
============

* Install the isort dependency:

.. code:: bash
    
    sudo pip install isort

* Add the plugin to vim using `Vundle <https://github.com/gmarik/vundle>`_ or any other plugin manager, pointing to this repo:

.. code::

    Bundle 'fisadev/vim-isort'

(Or if you don't use any plugin manager, you can just copy the ``python_vimisort.vim`` file to your ``.vim/ftplugin`` folder)

