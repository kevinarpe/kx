/ BCP loader for sybase10+ sqlserver7+  2MB to 25MB per second
/ requires k 2.9 2002-08-04  or later

/For any table t:

/ 1. bcp t out t.bcp -Usa -P    NATIVE/NO DELIMETER(hit return on all prompts)  
/ 2. rename bcp.fmt to t.fmt    OPTIONAL
/ 3. t:.bcp.load`t
/ 4. .d.save`t

/ there are (at least) 4 .bcp formats:
/   sqlserver(can detect from .fmt)
/   sybase to windows,linux,solaris  
/    load`t  assumes host format. otherwise use: lwin llin lsol
/ any format can be loaded from any O/S

\d .bcp  
AR:~_ic*|_bd 1  / little-endian?
NT:~~#_m

xs:{x -1_&|':0,~" "=x," "}	/ remove extra spaces
cut:{:[#y;(#x)_'(y _ss x)_ y:x,y;()]}

S:`CHAR`INT4`INT`FLT8`BINARY`DATETIME`DATETIME4`DATETIM4`BIT`INT1`TINYINT`INT2`SMALLINT`REAL`FLT4`MONEY`MONEY4`TEXT`NCHAR`IMAGE`NUMERIC`DECIMAL
T:"SiidCZDDbbbssffMmCCCNN"

/ we can load chunks if we find record breaks:  f0[flag;a;break;nbytes]

f0:{[flag;a;j;k] / 0 sybwin 1 syblin 2 sybsol
 n:cut["\t "m:" "_in*n]'xs'n:2_:[*r:@[0::;(a$:),".fmt";:];0:"bcp.fmt";*|r]
 t:T S?/:u:`$3_'n[;1];p:- 0$n[;2];w:0$n[;3];f:`$n[;6];if[~"D"=(t,"D")i:f?`date;f[i]:`date1]
 if[m;t[&(p=-4)&t="S"]:"C"]   / w[&t="d"]:8 for numeric?
 if[~m;i:-1=p;t[&u _lin`TEXT`IMAGE]:"Y"
  if[flag=0;p[i]:-10-w i:&i&~t _lin"SC"]
  if[flag=1;p[&i]:-12]
  if[flag=2;p[&i&t="S"]:-12]
  if[flag=3;p[&i&t="S"]:-2]]
 x:(t;p(~p)'w);if[(flag>1)=AR;x|:]  /flip
 a,:".bcp";r:.+(f;x 1::[j|k;(a;j;k);a]);r[~f i;`T]:`date`timestamp"Z"=t i:&t _lin"DZ"
 @[r;f@&u=`NCHAR;`${x@&(#x)#1 0}']}

f1:{f0[x;y;0;0]}
lwin:{f1[0;x]}
llin:{f1[1;x]}
lsol:{f1[2;x]}
lso3:{f1[3;x]}
load:{f1[:[NT;0;AR;1;2];x]}

\
8/4  linux/solaris load sqlsvr bcp's
1/16 .bcp.load`t  / lwin llin lsol   sybase:(windows linux solaris)
1/16  NUMERIC length prec scale sign? 8 or 12 or 16?

e.g.

\l db/odbc
e:.odbc.exec[.odbc.open`syb]
e"create table t(s varchar(5),i int,f float,b varbinary(3),d smalldatetime,z datetime,
 i0 bit not null,i1 tinyint,i2 smallint,f4 real,m0 money,m1 smallmoney,b0 text,b1 image,n numeric(18,2))"
e"insert into t values('kdb',-2,-2.3,0x616263,'1999-1-1','1999-1-1',1,255,-2,-2.3,-2.1234,-2.1234,'qwe',0x616263,3.25)"
e"insert into t(i0)values(0)"

\
sqlsvr varchar nulls are 255?
name -length width type
sqlsvr(" ") (-4 S) to (-4 C)
sybase(tab)  TEXT/IMAGE  is Y 
0. sybwin -1 nulls are 0 00 0000(-11 -12 -14)
1. syblin -1 nulls are 00(-12)
2. sybsol -1 syms are -2(b) (-12?cash_ticks)

300MHZ solaris 2MB/sec
450MHZ NT/linux 6MB/sec
1.7GHZ NT  22MB/sec

numeric goes to wd?number e.g. 1 11(18 2 ....)