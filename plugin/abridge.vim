" File: abridge.vim
" Author: justin domingue <domingue.justin@gmail.com>
" Last Change: Sun 30 Mar 11:09:26 2014
" Version: 1.0
" Usage:
" 
" call Abridge("from", "to", "filetype")
"         from : abbreviation
"           to : expanded expression
"     filetype : file type on which to apply the abbreviation ('*' for all
"     file types)
" 
" ,, select next placeholder
"

" SETUP {{{
" Do not load more than once, but allow the user to force reloading
if exists('loaded_abridge') && loaded_abridge == 1
  finish
endif
let loaded_abridge = 1

" Suffix expansion key
" Defaults to '.' (dot)
"   e.g. if snippet is 'for', expansion is triggered on 'for.'
if !exists("g:abridge_suffix_key")
  let g:abridge_suffix_key = '.'
endif

" _abridge_ holds the abbreviations
augroup abridge
  autocmd!    
 augroup END

" }}}

" FUNCTIONS {{{

" Help delete character if it is 'empty space'
" stolen from Vim manual
function! Eatchar()
  let c = nr2char(getchar())
  return (c =~ '\s') ? '' : c
endfunction

" Replace abbreviation if we're not in comment or other unwanted places
" stolen from Luc Hermitte's excellent http://hermitte.free.fr/vim/
function! ExpandIfSafe(key, seq)
  let syn = synIDattr(synID(line('.'),col('.')-1,1),'name')
  if syn =~? 'comment\|string\|character\|doxygen'
    return a:key
  else
    exe 'return "' .
    \ substitute( a:seq, '\\<\(.\{-}\)\\>', '"."\\<\1>"."', 'g' ) . '"'
  endif
endfunction

" Disable autoindent and autocomment
function! s:SetFormat()
  let g:formatOptionsTmp = &formatoptions
  set formatoptions = ""
  return ""
endfunction

" Enable autoindent and autocomment according to user's original settings
function! s:RestoreFormat()
  let &formatoptions = g:formatOptionsTmp
  return ""
endfunction

" Go to next match of pattern '<\d>' only if match is found in the rest of the
" file (no wrap). Otherwise, insert 'key'
function! s:SelectNextIfSafe(key)
  " Search for a match
  " cursor will move to start of match if there is one
  let next = search('<#.[^#]*#>', 'cw')

  " If no match, simply insert the key
  if next == 0
    return a:key
  " Otherwise, select next
  else
    " Uses mark A
    normal! 2xmAf#.h

    " Get char under cursor
    let char = getline('.')[col('.')-1]
    echom char

    " If char is dot, no placeholder
    if char == '-'
      normal! s
    else
      normal! v`A
    endif

    return ""
  endif
endfunction

" Helper function to add abbreviations according to a Filetype
function! Abridge(from, to, filetype)
  exec "autocmd abridge Filetype " . a:filetype . 
        \ " inoreab <silent> <buffer> " . a:from . g:abridge_suffix_key . " <C-R>=<SID>SetFormat()<CR><C-R>=ExpandIfSafe('" .
        \ a:from . "', '" .  escape(a:to, '<>\"') .
        \ "')<CR><C-O>:call <SID>SelectNextIfSafe('')<CR><C-R>=<SID>RestoreFormat()<CR>"
endfunction

" }}}

" MAPPINGS {{{

if !exists('g:abridge_map_keys')
    let g:abridge_map_keys = ",,"
endif

execute "noremap <silent> " . g:abridge_map_keys . " :call <SID>SelectNextIfSafe('" . g:abridge_map_keys . "')<CR>"
execute "inoremap <silent> " . g:abridge_map_keys . " <C-O>:call <SID>SelectNextIfSafe('" . g:abridge_map_keys . "')<CR>"

" }}}


" ABBREVIATION DEFINITIONS {{{

" Do not define the abbreviations if the user doesn't want to
" User has to put `let abridge_abbreviations = 1` in it's vimrc
if exists('abridge_default_abb')
  finish
endif

" C {{{

" flow control
call Abridge("if", "if (<#-#>) {<cr><#-#><CR>}", "c,cpp")
call Abridge("ife", "if (<#-#>) {<CR><#/* code */#><CR>} else {<CR><#/* code */#><CR>}", "c,cpp")
call Abridge("swi", "switch (<#var#>) {<CR>case <#val#>:<CR>}", "c,cpp")

" loops
call Abridge("for", "for (<#int i = 0#>; <#i < 9#>; <#i++#>) {<CR><#/* code */#><CR>}", "c,cpp")
call Abridge("wh", "while (<#-#>) {<CR><#/* code */#><CR>}", "c,cpp")
call Abridge("dowh", "do {<CR><CR>} while(<#-#>);", "c,cpp")

" variables
call Abridge("inti", "int i = 0;<##>", "c,cpp")

" functions
call Abridge("funi", "int <1>(<2>) {<CR><3><CR>}", "c,cpp")
call Abridge("funip", "int <1>(<2>);", "c,cpp")
call Abridge("fun", "<1> <2>(<3>) {<CR><3><CR>}", "c,cpp")
call Abridge("funp", "<1> <2>(<3>);", "c,cpp")

" operators
call Abridge("tern", "<1> ? <2> : <3>;", "c,cpp")

" structs
call Abridge("stru", "struct <1> {<CR><2><CR>};", "c,cpp")
call Abridge("strut", "typedef struct <1> {<CR><2><CR>};", "c,cpp")

" C preprocessor directives
call Abridge("#i", "#include <<1>>", "c,cpp")
call Abridge("#I", '#include "<1>"', "c,cpp")
call Abridge("#d", "#define <1>", "c,cpp")

" Templates
call Abridge("main", "int main(int argc, char *argv[]) {<CR><1><CR>}", "c,cpp")"

" }}}

" JavaScript {{{

call Abridge("fun", "function <1>(<2>) {<cr><3><cr>}", "javascript")

" }}}

" Vim Script {{{

" header comment
call Abridge("-h-", '" File: ' . @% . '<CR>" Author: <1><CR>" Last Change: <2><CR>" Version: <3><CR>" Usage: <4>', 'vim')
call Abridge("abridge", "call Abridge(\"<1>\", \"<2>\", \"<3>\"", "vim")

" }}}
"
" }}}
