" File: abridge.vim
" Author: justin domingue <domingue.justin@gmail.com>
" Last Change: Sun 30 Mar 11:09:26 2014
" Version: 1.0
" Usage:

if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "abridge"

" SYNTAX {{{
" syntax highlighting for abridge placeholders

autocmd Syntax * syntax match abridgePlaceholder "<#.[^#]*#>" containedin=ALL
highlight link abridgePlaceholder Comment

" }}}
