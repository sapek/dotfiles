set nocp
set backspace=indent,eol,start
set cindent
let mapleader = ","
let maplocalleader = ","
let g:pandoc_use_hard_wraps = 1
let g:pandoc_auto_format = 1
let g:pandoc_no_empty_implicits = 1
let g:LatexBox_viewer = "open"
let g:pandoc#syntax#conceal#use = 0
let g:pandoc#syntax#codeblocks#embeds#langs = ["cpp", "python", "bash=sh", "cs"]
let g:solarized_italic = 0
let g:solarized_termtrans = 1
let g:haskell_conceal = 0

"set clipboard=unnamed
set expandtab

" c - wrap comments at textwidth
" o - insert comment leader when adding a line in a comment block
" q - allow formating paragraph with gq
" 1 - try not to break with one letter word at the end of line
"set formatoptions+=coq1

" Recognize - and * as list header
set formatlistpat=^\\s*[0-9*-]\\+[\\]:.)}\\t\ ]\\s*

set history=500

set laststatus=2

" search is case insensitive unless search term contains uppercase char
set ignorecase
set smartcase
set hlsearch
set incsearch

" no wrapping by default but break lines on word boundary when wrapping is on
set lbr
set nowrap
" map <leader> w to toggle line wrapping, also enable cursor line when wrapping
nmap <silent> <leader>w :set cursorline! wrap!<CR>

set number
set ruler
set shiftwidth=4
set showmatch
set title
set ts=4
set virtualedit=all
set diffopt+=iwhite

let OmniCpp_MayCompleteDot = 1      " auto-complete with .
let OmniCpp_MayCompleteArrow = 1    " auto-complete with ->
let OmniCpp_MayCompleteScope = 1    " auto-complete with ::
let OmniCpp_SelectFirstItem = 2     " select first item (but don't insert)
let OmniCpp_NamespaceSearch = 2     " search name-spaces in this and included files
let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype (i.e. parameters) in popup window
let OmniCpp_ShowAccess = 0
let OmniCpp_ShowScopeInAbbr = 0
let OmniCpp_LocalSearchDecl = 1
set completeopt=menu,menuone

filetype indent on
filetype plugin on
filetype on
syntax on

" colorscheme adamsap

" command completion a la shell
set wildmode=list:longest
" ignore files with these extensions in command completion
set wildignore=*.o,*.obj,*.exe,*.bin

" start scrolling 3 lines from the bottom
set scrolloff=3

" show/hide white spaces with \s
nmap <silent> <leader>s :set nolist!<CR>

" use Tab for completion except at the beginning of line or after a tab
inoremap <tab> <c-r>=InsertTabWrapper ("forw")<cr>
inoremap <s-tab> <c-r>=InsertTabWrapper ("back")<cr>

function! InsertTabWrapper(direction)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    elseif "back" == a:direction
        return "\<c-p>"
    else
        return "\<c-n>"
    endif
endfunction

" Open file under cursor in a new tab
nnoremap gf <c-w>gf

" map F1 to help for word under cursor
map <silent> <F1> "zyiw:exe "h ".@z.""<CR>
" map <silent> [Z :tabprev<CR>
" map <silent> <F3> :NERDTreeToggle<CR>

" map F4 and Shift-F4 to next/previous compilation error
map <silent> <F4> :cn<CR>
map <silent> <S-F4> :cp<CR>

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"Fuzzy finder mappings
nmap <silent> <leader>f :FufFile<CR>
nmap <silent> <leader>b :FufBuffer<CR>
nmap <silent> <leader>h :FufHelp<CR>

"au VimLeave * mksession! ~/.vimsession.vim
"au VimEnter * source ~/.vimsession.vim

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

if has("autocmd")
  " Source the .vimrc file after saving it
  autocmd bufwritepost .vimrc source $MYVIMRC

  " When editing a file, always jump to the last known cursor position.  Don't
  " do it when the position is invalid or when inside an event handler (happens
  " when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
endif

set sessionoptions+=resize,winpos
set sessionoptions-=options

call pathogen#infect()

set background=dark
colorscheme solarized

exe "hi! link hsDelimiter Statement"
exe "hi! link hsStructure PreProc"
exe "hi! link hsExprKeyword Statement"

autocmd BufRead,BufNewFile *.txt set filetype=doc
autocmd BufRead,BufNewFile CMakeLists.txt set filetype=cmake
autocmd FileType c,cpp,haskell,xml :set textwidth=79
autocmd FileType c,cpp,haskell :set foldlevel=20
autocmd FileType haskell :syntax sync fromstart
autocmd FileType gitcommit,pandoc,doc :set nocindent
autocmd FileType gitcommit set tw=72
autocmd FileType xml set tabstop=2
autocmd FileType pandoc,doc :set autoindent
autocmd FileType pandoc,doc :set spell
" autocmd FileType pandoc,doc :set fo-=w
autocmd FileType pandoc,doc :set fo+=tn1
" spell check Git commits
autocmd BufNewFile,BufRead COMMIT_EDITMSG set spell
" remove trailing white spaces in pandoc files
" autocmd FileType pandoc autocmd BufWritePre <buffer> :%s/\s\+$//e
" auto-cleanup fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete
