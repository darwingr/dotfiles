" ~/.vim/after/syntax/sh.vim
"
" https://subvisual.co/blog/posts/87-smarter-heredoc-syntax-in-vim/

let s:bcs = b:current_syntax

unlet b:current_syntax
syntax include @SQL syntax/sql.vim

" this unlet instruction is needed
" before we load each new syntax
unlet b:current_syntax
syntax include @TeX syntax/tex.vim


"syntax region hereDocText matchgroup=Statement
"  \ start=+<<[-~.]*\z([A-Z]\+\)+
"  \ end=+^\s*\z1+
"  \ contains=NONE

" Known to work in ruby for:
" sql_heredoc = <<~SQLDOC
"   SELECT id, name
"   FROM users
"   WHERE team_id = '1'
" SQLDOC
syntax region hereDocBashSQL
  \ matchgroup=Statement
  \ start=+<<[-~.]*\z(SQLDOC\)+
  \ end=+^\s*\z1+
  \ contains=@SQL
  \ containedin=@shCaseList,shCommandSubList,shFunctionList


" shStatement is the syntax applied to start and end
syntax region hereDocBashTeX
  \ matchgroup=shRedir
  \ keepend
  \ start=+<<[-~.]*\s*\z(TEXDOC\).*$+
  \ end=+^\s*\z1$+
  \ contains=@TeX
  \ containedin=@shCaseList,shCommandSubList,shFunctionList


let b:current_syntax = s:bcs
