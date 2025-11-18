syntax on
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

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


" --- Expand 'classdef' into a canonical C++ class template ---
function! ClassDef()
    let class = expand('%:t:r')
    let text = "class   " . class . " {\n" .
        \ " public:\n" .
        \ "    " . class . "();\n" .
        \ "    " . class . "(const " . class . "& other);\n" .
        \ "    " . class . "& operator=(const " . class . "& other);\n" .
        \ "    ~" . class . "();\n\n" .
        \ " private:\n" .
        \ "    // Add members here\n" .
        \ "};"

    " Temporarily disable indentation while inserting
    setlocal noautoindent nocindent nosmartindent
    call append(line('.') - 1, split(text, "\n"))
    setlocal autoindent cindent smartindent
endfunction

function! ClassImp()
    let class = expand('%:t:r')
    let text = class . "::" . class . "() { }\n\n" .
        \ class . "::" . class . "(const " . class . "& other) {\n" .
        \ "    *this = other;\n" .
        \ "}\n\n" .
        \ class . "& " . class . "::operator=(const " . class . "& other) {\n" .
        \ "    if (this != &other) {\n" .
        \ "        // Copy members\n" .
        \ "    }\n" .
        \ "    return *this;\n" .
        \ "}\n\n" .
        \ class . "::~" . class . "() { }\n"

    " Temporarily disable indentation while inserting
    setlocal noautoindent nocindent nosmartindent
    call append(line('.') - 1, split(text, "\n"))
    setlocal autoindent cindent smartindent
endfunction

" Create an abbreviation usable in insert mode
command! ClassDef silent! call ClassDef()
command! ClassImp silent! call ClassImp()

"Function to insert a header at the top of the file"
function! Header()
    normal! gg

    call append(0, [
    \ '/**************************************************************************',
    \ ' * File: ' . expand('%:t'),
    \ ' * Author: Your Name <your.email@example.com>',
    \ ' * Created: ' . strftime("%Y-%m-%d"),
    \ ' *',
    \ ' * Copyright (c) ' . strftime("%Y") . ' Your Name',
    \ ' *',
    \ ' * This software is released under the MIT License.',
    \ ' * See https://opensource.org/licenses/MIT for details.',
    \ ' **************************************************************************/',
    \ ''
    \ ])
endfunction

command! Header call Header()

"Function to insert protection to .h files"
function! HeaderProtection()
    let l:filename = expand('%:t')
    let l:guard = toupper(substitute(l:filename, '\.', '_', 'g')) . '_'
    call append(0, '#ifndef ' . l:guard)
    call append(1, '# define ' . l:guard)
    call append(line('$'), '#endif')
endfunction

command! HeaderProtection call HeaderProtection()
