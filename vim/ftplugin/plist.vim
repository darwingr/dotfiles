" Vim syntax file 
" Language:	plist
" Created: 	01 Apr 08
" Last Change: 9 Sept 08
" By:	H.A.Trujillo

" coloring for plist files -- make the keys stand out 
"		 -- fold arrays



" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif



" Commented lines are cyan
 syn match	Comment 		/#.*$/	
 syn region	Comment	start=/<!--/	end=/-->/

" keys
 syn match 	pl_keys		"<key.*/key>" contains=pl_kflag

" values are default foreground

" Booleans are hybrid
 syn match	pl_bool	transparent	"<\(true\|false\)/>"	contains=pl_bflag
 syn match	pl_bflag	contained	"<\|/>"

" Other 1-word items are like bools
 syn match	pl_bool	transparent	"<\(array\|dict\)/>"	contains=pl_bflag

" regular flags 		(these match <xxx> and <\xxx> )
 syn match 	pl_kflag	contained	"<\(/\)\?key>"
 syn match 	pl_vflag 		"<\(/\)\?string>"
 syn match 	pl_vflag 		"<\(/\)\?real>"
 syn match 	pl_vflag 		"<\(/\)\?bool>"
 syn match 	pl_vflag 		"<\(/\)\?data>"
 syn match 	pl_vflag 		"<\(/\)\?integer>"
 syn match 	pl_vflag 		"<\(/\)\?date>"
 syn match 	pl_vflag 		"<\(/\)\?number>"

" special flags 
 syn match 	pl_sflag 		"<\(/\)\?array>"
 syn match 	pl_sflag 		"<\(/\)\?dict>"



" link to default groups
 hi link	pl_bflag	PreProc	" Blue
 hi link	pl_flags	PreProc	" Blue
 hi link	pl_kflag	PreProc	" Blue
 hi link	pl_vflag	PreProc	" Blue
"hi link	pl_bflag	Special	" Purple
"hi link	pl_flags	Special	" Purple
"hi link	pl_kflag	Special	" Purple
"hi link	pl_vflag	Special	" Purple

 hi link	pl_sflag	Type	" Green
 hi link	pl_keys	Statement	" Yellow
 hi link	pl_comment	Comment	" Cyan


" mellower coloring than default 
 highlight foldcolumn	ctermfg=8	ctermbg=8	
 highlight folded	ctermfg=NONE	ctermbg=NONE	cterm=reverse



set tabstop=4

set foldmethod=indent
set foldcolumn=3
set foldminlines=6
set foldlevel=4


let b:current_syntax = "plist"

"				 vim: ts=13 tw=0
