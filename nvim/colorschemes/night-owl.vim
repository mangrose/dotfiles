" Settings for Night Owl colorscheme
" https://github.com/haishanh/night-owl.vim

set termguicolors
set background=dark

silent! colorscheme night-owl

highlight clear CursorColumn
highlight clear ColorColumn
highlight link CursorColumn CursorLine
highlight link ColorColumn CursorLine

let g:indentLine_color_gui = '#1d3b53'

let g:lightline = {
    \   'colorscheme': 'nightowl',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
