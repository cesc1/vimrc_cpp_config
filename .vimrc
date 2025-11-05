syntax on
set tabstop=4
set shiftwidth=4

" ----------------------"
" Basic config for C/C++
" ----------------------"

" Auto indent
filetype plugin indent on
syntax on

" Acttivate smart indent
set smartindent
set autoindent

" Detect type of file
autocmd FileType c,cpp setlocal cindent

" Settings of cindent (Linux style)
set cinoptions=:0,l1,t0,g0,g0,(0,W4

" Mostrar partes de llaves
set showmatch

" Quitar espacios al final
autocmd BufWritePre * :%s/\s\+$//e

" Auto indent in {}
inoremap { {<CR>}<Esc>O

" Colorea columnas > 80 chars
set colorcolumn=80
highlight ColorColumn ctermbg=darkgray

" Better autocomplete
set completeopt=menuone,noselect


" --- Expand 'classdef' into a C++ class template ---
function! InsertCppClassTemplate()
    return "class\t" . expand('%:t:r') . " {\n\n" .
        \ "public:\n" .
        \ "\t" . expand('%:t:r') . "();\n" .
        \ "\t~" . expand('%:t:r') . "();\n\n" .
        \ "private:\n\n" .
        \ "};"
endfunction

" Create an abbreviation usable in insert mode
inoreabbrev <expr> classdef InsertCppClassTemplate()
