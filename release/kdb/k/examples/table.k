/ copyright(c) kx systems

/ tables and views

/ make a relational table with 100000 rows?
t:.+(`a`b`c`d;4 100000 _draw 10)

/ show t?
`show$`t

/ make a view of t?
view..d:"@[t;_n;@[;i]]"	/ v depends on amend t with indices i
`show$`view				/ i is null

/ sort t according to `a?
i:<t`a		/ indices are upgrade t`a

/ subselect t according to `a > 0?
i:`t"&a>0"	/ select t where a > 0

/ multi-column constraint?
f:(0<;2>;2=)	/ 3 boolean valued functions
i:&&/f@'t`a`b`c	/ i is where and OVER f at EACH t`a`b`c

/ converge on the indices?
f:(&0<;&2>;&2=)	/ 3 index valued functions
i:{x y z x}/[_n;f;t`a`b`c]		/ i gets {x at y at z at x}OVER

/ multi-column sort?
f:(<:;>:;<:)	/ functions are (up;down;up)
i:{x y z x}/[_n;f;t`c`b`a]		/ i gets {x at y at z at x}OVER

/ write a table viewer to execute arbitrary selections?
index:""
view..d:"@[t;_n;@[;`t index]]"	/ execute index in context of t
.k..a:`index`view
.k..c:`form
`show$`.k

index:"<a"					/ sort up by a		
index:"&(0<a)&(2>b)&2=c"	/ where(0<a)and(2>b)and 2=c

