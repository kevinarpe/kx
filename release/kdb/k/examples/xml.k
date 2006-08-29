/ xml: (tag;data|xml+;(attr;value)*)  dtd: element(,|?+*) attlist entity

\d .xml
L:"<";W:"\t\r\n",B:" ";S:"/";R:">";cut:{:[#y;(#x)_'(y _ss x)_ y:x,y;()]};join:{(#x)_(0#x),/x,/:y}

oc:1!";&#",_ci 48+8 8 8 _vs*_ic	/ octal from char, e.g. oc"a"
co:_ci,8 _sv -48+_ic 3_-1!	/ char from octal, e.g. co"&#141;"
xc:_ssr/[;"&<>'",,"[\200-\377]";("&amp;";"&lt;";"&gt;";"&apos;";oc)]	/ xml from char
cx:_ssr/[;("&amp;";"&lt;";"&gt;";"&apos;";"&#???;");"&<>'",co]		/ char from xml

ex:{(&b&1=+\(b&:~e)-(c&1!R=x)|e:(b:L=x)&1!c:S=x)_ x} / element from xml
/ (s;v[;a]) from xml
dx:{a:(-S=*|a)_ a:(1+m:s?B)_ s:_ssr/[;W;B](n:x?R)#x;x:(-m+1)_(*i)_(*|i:&~x _lin W)#x:(1+n)_ x
 (`$1_ m#s;:[L=*x;_f'ex x;cx x]),:[~#a@:&0<#:'a:cut[B]a;a;,{(`$n#x;-1_(2+n:x?"=")_ x)}'a]}

/ xml from (s;v[;a])
xd:{s:$*x;L,s,:[2=#x;"";,/B,'{($*x),"='",(*|x),"'"}'x 2],:[#v:x 1;R,:[4:v:x 1;xc v;,/_f'v],L,S,s;S],R}

indent:{s:1+y?R;e:-1-(|y)?L;:[~L=*t:s _ e _ y;,x,y;(,x,s#y),(,/_f[B,x]'ex t),,x,e#y]}[""]
DX:{dx@,/x@&~(x:(&b&1=+\(b:x=L)-x=R)_ x)[;1]_lin"?!"}
XD:join["\n"](,"<?xml version='1.0' encoding='UTF-8'?>"),indent xd@

xd d:dx x:"<g><f a='2'/><h>34</h><i b='3' c='asdf'>asdf</i></g>"
DX XD d
\

`d.xml 6:x:XD d
d:DX x:6:`d.xml

0. flip? datatypes?

1. attribute dictionaries.

2. xget[x;p] xset[x;p;v]
where p is (`e;i) pairs(elided i to 0?)
e.g. xget[x;((`record;0);`stock)]
x[record[0].stock]

exercises:

write an XML parser in K. result is recursive (tag;value;attrs).

add to the parser to recognize atoms, lists, dicts and tables. e.g.

<a>2</a>
<l><a>2</a><a>3</a></l>
<d><a>2</a><b>3</b></d>
<t><d>...</d><d>....</d></t>

(also handle data types)

map to flat relational. see http://www.extensibility.com/main_modeling.htm
(also consider adorecordset.save xml)
