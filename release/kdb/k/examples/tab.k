/ copyright(c) kx systems

/ gui, textfile i/o, excel, table manipulation
/ tab.txt is a tab delimited text file with
/  stock price amount date

/ how do i read in a tab delimited file?
r:0:`tab.txt		/ rows is read t.txt

/ how do i cut each record on the tabs?
cut:{1_'(&x=*x)_ x:"\t",x}	/ cut is a function of x
/ 1 drop EACH (where x equals first x) cut x is tab prepend x

d:cut'r			/ data is cut EACH row

l:`$*d			/ labels are symbols first data

c:+1_ d			/ columns are flip rest data

t:.+(l;c)		/ table is dot flip (labels;columns)

/ how do i show the table?
`show$`t

/ how do i edit the table?
/ type on the display ...

/ how do i reform the labels and records?
join:{1_,/"\t",'x}		/ join is a function
/ 1 drop join OVER tab prepend EACH

r:join'(,$!t),+t[] / rows are join EACH (string labels t) prepend flip t data

/ how do i write it out?
`tab.txt 0:r		/ t.txt write data

/ how do i convert the columns?
`hide$`t
t[]:(`;0;0.0;0)$t[]	 / columns are (sym;int;float;int) form columns
`show$`t

/ how do i edit the table?
/ type on the display ...

/ how do i convert the columns back to strings?
$t[]

/ how do i put it all together?

read:{[file]t::.+(`$*d;(`;0;0.0;0)$+1_ d:cut'0:file);`show$`t}

write:{[file]file 0:join'(,$!t),+$t[]}

/ how do i put 100,000 thousand rows into t?
t[]:100000#'t[]		/ tdata is 100000 take EACH tdata

/ how do i keep the first 2 rows?
t[]:2#'t[]			/ tdata is 2 take EACH tdata

write `tab.txt