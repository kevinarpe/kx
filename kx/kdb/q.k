/ k3/q connectivity  lin/sol need k3 2004-07-25 or later(clashes)
/q -p 5001

f:"lin/q" /lin/sol

c:(f 2:("qhp";2))[`;5001]
q:f 2:("q";2)   / q[c]"..."  or  q[c]("..";x;y;z)

q[c]"23"

\l db
t:.d.r"([]i:(2,3),f:(2.3,4.5),s:('a','b'),d:date('20000101',''))"
q[c]("::";23)
q[c]("::";t)


\

for async push to k3 from q> `http://:1234 "a:2" etc.

k	q
int:	int,bool,byte,short
float:	float,long,real
table:	table
