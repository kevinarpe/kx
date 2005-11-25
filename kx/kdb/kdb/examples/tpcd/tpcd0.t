/d -s .1 -f

\\cd \t100

r:'r'key(('r'),' S  ','|')load'region.tbl'
n:'n'key(('n','r'),' SI  ','|')load'nation.tbl'
s:'s'key(('s','ca','n','cp','x','cz'),' CCICFC ','|')load'supplier.tbl'
p:'p'key(('p','name','cm','b','t','z','e','x'),'ISSSSISF  ','|')load'part.tbl'
:ps:('p','s')key(('p','s','q','x'),'IIIF  ','|')load'partsupp.tbl'
:c:'c'key(('c','ca','n','cp','x','m','cz'),' CCICFSC ','|')load'customer.tbl'
:o:'o'key(('o','c','a','x','d','j','k','i','cz'),'IISFDSSIC ','|')load'order.tbl'
:l:(('o','p','s','q','x','xd','xt','v','u','ds','dc','dr','i','h'),'III IFFFSSDDDSS  ','|')load'lineitem.tbl'

:'d'asc'o'
:l.o:o l.o  # enumerate
\`ps`o`l@[;;-;1]'(`p`s;`c;`p`s);
\`p`c`o`l{.[y;();:;t@:<t:?x y];@[x;y;t?/:];.[x;(~y;`T);:;y]}''(`b`t`e;`m;`a`j`k;`v`u`h`i);
\`n`s`ps`c`o`l{.[x;(~y;`T);:;y]}'(`r;`n;`p`s;`n;`c;`o`p`s);

/:'o'asc'l'
/:'ds'index'l'


update rev:x*1-xd from'l'		# precalc revenue

\Q:("select sum q,sum x,sum rev,sum rev*1+xt,sum xd,count$by v,u from l where ds<=date['1998-12-01']-90"
 "100 first desc select p,s,s.n,p.cm,s.ca,s.cp,s.cz,s.x from ps where p.z=15,p.t like'*BRASS',s.n.r='EUROPE',x=min x by p"
 "10 first desc select sum rev by o,o.d,o.i from l where o.c.m='BUILDING',o.d<'1995-03-15',ds>'1995-03-15'"
 "select count$by j from o where d.quarter='1993Q3',$in select o from l where dc<dr"
 "desc select sum rev by s.n from l where o.c.n=s.n,s.n.r='ASIA',o.d.year=1994"
 "select sum x*xd from l where ds.year=1994,xd within(.05,.07),q<24"
 "select sum rev by sn:s.n,cn:o.c.n,ds.year from l where ds.year in(1995,1996),((s.n='FRANCE')and o.c.n='GERMANY')or(s.n='GERMANY')and o.c.n='FRANCE'"
 "select rev avg s.n='BRAZIL'by o.d.year from l where o.c.n.r='AMERICA',o.d.year in(1995,1996),p.t='ECONOMY ANODIZED STEEL'"
 "select sum rev-ps[p,s].x*q by s.n,o.d.year from l where p.name like'*green*'"
 "20 first desc select sum rev by o.c,o.c.x,o.c.n,o.c.ca,o.c.cp,o.c.cz from l where o.d.quarter='1993Q4',v='R'"
 "desc select from(select sum x*q by p from ps where s.n='GERMANY')where x>sum x/count s"
 "select low:sum o.j<='2-HIGH',high:sum o.j>'2-HIGH'by h from l where h in('MAIL','SHIP'),dc<dr,ds<dc,dr.year=1994"
 "select sum rev by o.d.year from l where o.k='Clerk#000000088',v='R'"
 "select 100*rev avg p.t like'PROMO*'from l where ds.month='1995M09'"
 "select s,s.ca,s.cp,rev from(select sum rev by s from l where ds.quarter='1996Q1')where rev=max rev"
 "desc select count distinct s by p.b,p.t,p.z from ps where p.b<>'Brand#45',not p.t like'MEDIUM POLISHED*',p.z in(49,14,23,45,19,3,36,9),not s.cz like'*Better Business Bureau*Complaints*'"
 "select sum x/7 from l where p.b='Brand#23',p.e='MED BOX',q<.2*avg q by p")

:save'/t100.kdb'

