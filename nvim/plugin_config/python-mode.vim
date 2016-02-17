let g:python_host_prog = $PYENV_ROOT . '/versions/2.7.10/bin/python'
let g:python3_host_prog = $PYENV_ROOT . '/versions/3.5.0/bin/python'

" Disable linters, since Neomake will handle linting instead
let g:pymode_lint_checkers = []

" Use Ctrl-] to look up the definition of some variable/method, just like in
" other parts of Vim
let g:pymode_rope_goto_definition_bind = "<C-]>"

" Disable Rope completion
let g:pymode_rope_completion = 0

" Disable PyDoc integration in favor of Jedi
let g:pymode_doc = 0
let g:pymode_doc_bind = ''
