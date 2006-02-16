/ k3/q connectivity lin/sol need k3 2005-01-05 or later(because of earlier clashes)
/q -p 5001

f:"win/q" /lin/sol

h:(f 2:("qhp";2))[`;5001]
q:f 2:("q";2)
q[h]"23"
q[-h]"h:.z.w"
.m.g:.m.s:.:         /  q> (neg h)"a:2"
\



\l db
t:.d.r"([i:(2,3)]f:(2.3,4.5),s:('a','b'),d:date('20000101',''))"
q[h]("::";t)

\


k	q
int:	int,bool,byte,short
float:	float,long,real
table:	table

h:(f 2:("qhpu";3))[`;5001;`$"usr:pwd"]