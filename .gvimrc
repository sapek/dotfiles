set selectmode=mouse
" -T - no toolbar
" -m - no menubard
" +c - consol messages instead of dialog boxes
set guioptions-=T
set guioptions-=m
set guioptions+=c

if has("gui_macvim")
    let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
    set guifont=inconsolata-dz:h13
    set lines=49 columns=124
    set visualbell
    " copy gist url to clipboard
    let g:gist_clip_command = 'pbcopy'
elseif has("unix")
    let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
    set guifont=Inconsolata\ Medium\ 13
    set lines=43 columns=90
else
    let Tlist_Ctags_Cmd='"C:\Program Files (x86)\Vim\ctags"'
    set guifont=consolas:h10
    set lines=40 columns=100
endif

" clear search highlight with Esc
nmap <silent> <Esc> :noh<CR>

" map Tab key for switching between buffers
map <silent> <C-Tab> :bn<CR>
map <silent> <C-S-Tab> :bp<CR>

" scroll screen with Ctrl+up/down
nnoremap <C-Down> 3<C-e>
nnoremap <C-Up> 3<C-y>

" allow hidden unsaved buffers
set hidden

function! RemapQ()
    return getcmdtype() == ':' && getcmdpos() == 1 && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
endfunction

" Use :q and :wq to close buffer, unless it is the last one, then just quit
:cabbrev           q <c-r>=(RemapQ() ? 'bd' : 'q')<CR>
:cabbrev <silent> wq <c-r>=(RemapQ() ? 'w<bar>bd' : 'wq')<CR>

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

