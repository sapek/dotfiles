" Vim color file
" Maintainer: vim@work.sapek.com 
" Last Change:  
" URL:		

" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

" your pick:
set background=dark	" or light

hi clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name="adamsap"

" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine guibg=#0F436E cterm=none ctermbg=4
  hi CursorColumn guibg=#0F436E cterm=none ctermbg=4
  hi MatchParen guifg=NONE guibg=#384948 gui=none ctermfg=none ctermbg=0 cterm=none 
  hi Pmenu 		guifg=#C7C7C7 guibg=#0F436E ctermfg=7 ctermbg=4
  hi PmenuSel 	guifg=#C7C7C7 guibg=#520804 ctermfg=7 ctermbg=1
endif

" General colors
hi Cursor 		guifg=NONE    guibg=#1417DB gui=none 
hi Normal 		guifg=#AAAAAA guibg=#202020 gui=none ctermfg=7 
hi NonText 		guifg=#808080 guibg=#303030 gui=none ctermfg=7 
hi SignColumn   guibg=#101010
hi LineNr 		guifg=#2B91AF guibg=#101010 gui=none ctermfg=7
hi StatusLine 	guifg=#AAAAAA guibg=#000000 gui=none ctermfg=0 ctermbg=7
hi StatusLineNC guifg=#808080 guibg=#303030 gui=none ctermfg=7 ctermbg=0
hi VertSplit 	guifg=#444444 guibg=#000000 gui=none ctermfg=7 ctermbg=0
hi Folded 		guibg=#384048 guifg=#a0a8b0 gui=none ctermbg=4 ctermfg=7
hi Title		guifg=#f6f3e8 guibg=NONE	gui=none ctermfg=7
hi Visual		guifg=NONE    guibg=#0F436E gui=none cterm=none ctermbg=4
hi SpecialKey	guifg=#808080 guibg=#343434 gui=none ctermfg=7
hi DiffAdd      guifg=NONE    guibg=#013808 gui=none
hi DiffChange   guifg=NONE    guibg=#323232 gui=none        
hi DiffDelete   guifg=NONE    guibg=#750600 gui=none
hi DiffText     guifg=NONE    guibg=#002178 gui=none

" Syntax highlighting
hi Comment 		guifg=#5FA83B gui=none ctermfg=2
hi Boolean      guifg=#BA3622 gui=none ctermfg=1
hi String 		guifg=#BA3622 gui=none ctermfg=1
hi Identifier 	guifg=#BA3622 gui=none ctermfg=1
hi Constant 	guifg=#BA3622 gui=none ctermfg=1
hi Number		guifg=#BA3622 gui=none ctermfg=1
hi Operator 	guifg=#ff9800 gui=none ctermfg=3
hi Function 	guifg=#ff9800 gui=none ctermfg=3
hi Type 		guifg=#ff9800 gui=none ctermfg=3
hi Statement 	guifg=#ff9800 gui=none ctermfg=3
hi Keyword		guifg=#ff9800 gui=none ctermfg=3
hi Special		guifg=#ff9800 gui=none ctermfg=3
hi PreProc 		guifg=#ff9800 gui=none ctermfg=3
hi Todo         guifg=#202020 guibg=#e6ea50 gui=none ctermfg=0 ctermbg=3

if &t_Co == 256
    if version >= 700
      hi CursorLine   ctermbg=24
      hi CursorColumn ctermbg=24
      hi MatchParen   ctermfg=none ctermbg=236 cterm=none 
      hi Pmenu 		  ctermfg=250 ctermbg=24
      hi PmenuSel 	  ctermfg=250 ctermbg=52
    endif

    hi Cursor 		ctermfg=NONE ctermbg=20
    hi Normal 		ctermfg=250  ctermbg=234
    hi NonText 		ctermfg=244  ctermbg=236
    hi LineNr 		ctermfg=31  ctermbg=232
    hi StatusLine 	ctermfg=253  ctermbg=232 cterm=none
    hi StatusLineNC ctermfg=253  ctermbg=238
    hi VertSplit 	ctermfg=253  ctermbg=238
    hi Folded 		ctermfg=253  ctermbg=244 
    hi Title		ctermfg=254  cterm=none
    hi Visual		ctermfg=NONE ctermbg=24
    hi SpecialKey	ctermfg=244  ctermbg=236
    hi Comment 		ctermfg=28
    hi Boolean      ctermfg=124
    hi String 		ctermfg=124
    hi Identifier 	ctermfg=124 cterm=none
    hi Constant 	ctermfg=124
    hi Number		ctermfg=124
    hi Operator 	ctermfg=172
    hi Function 	ctermfg=172
    hi Type 		ctermfg=172
    hi Statement 	ctermfg=172
    hi Keyword		ctermfg=172
    hi Special		ctermfg=172
    hi PreProc 		ctermfg=172
    hi Todo         ctermbg=220 ctermfg=235
endif

if &term == "win32" || &term == "cygwin"
    if version >= 700
      hi CursorLine   ctermbg=1
      hi CursorColumn ctermbg=1
      hi MatchParen   ctermfg=none ctermbg=8 cterm=none 
      hi Pmenu 		  ctermfg=7 ctermbg=1
      hi PmenuSel 	  ctermfg=7 ctermbg=4
    endif

    hi Normal 		ctermfg=7  ctermbg=0
    hi NonText 		ctermfg=7  ctermbg=8
    hi LineNr 		ctermfg=11  ctermbg=3
    hi StatusLine 	ctermfg=15  ctermbg=3
    hi StatusLineNC ctermfg=15  ctermbg=8
    hi VertSplit 	ctermfg=15  ctermbg=3
    hi Folded 		ctermfg=15  ctermbg=8 
    hi Title		ctermfg=15  cterm=none
    hi Visual		ctermfg=NONE ctermbg=1
    hi SpecialKey	ctermfg=7  ctermbg=8
    hi Comment 		ctermfg=10
    hi Boolean      ctermfg=12
    hi String 		ctermfg=12
    hi Identifier 	ctermfg=12 cterm=none
    hi Constant 	ctermfg=12
    hi Number		ctermfg=12
    hi Operator 	ctermfg=6
    hi Function 	ctermfg=6
    hi Type 		ctermfg=6
    hi Statement 	ctermfg=6
    hi Keyword		ctermfg=6
    hi Special		ctermfg=6
    hi PreProc 		ctermfg=6
    hi Todo         ctermfg=0 ctermbg=14
endif
