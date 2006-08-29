/ to read k
/ find the words (scan from left to right)
/ disambiguate the verbs and remove the silent :'s

/ space left right adverb verb
s:" \t";l:"({[;\n";r:")}]";a:"'/\\";v:"+-*%&|<>=^!~,#_$?@."

/ class 
c:@[-1+&256;_ic c;:;!#c:(s,l;r;v;a;".",_ci,/65 97+\:!26;"0123456789"),"\"`_-:e\\/\n"]@_ic

/ transitions ': ab 01e qrst
t:t[;0]?/:/:1_'t:1_'(&"\n"=t)_ t:1_("
 ;)+'a0q`_-:e\/n
;;)+'a0q`_-+a'/;
);)+'a0q`_++a'';
+;)+'a0q`_-+a'';
';)+'a0q`_-:a'';
a;)+'bbq`b++b'';
0;)+'11q`_+:e'';
qrrrrrrtrrrrrsrr
`;)+'b0q`b++b'';
_;)+'b0q`_-+b'';
-;)+'a1q`_-+a'';
/cccccccccccccc;
ccccccccccccccc;
:;)+'a0q`_-+a'';
b;)+'bbq`b++b'';
1;)+'11q`_++e'';
e;)+'11q`_1+1'';
rrrrrrrtrrrrrsrr
srrrrrrrrrrrrrrr
t;)+'a0q`_++a'';")

/ words, e.g. w"2+3"  delete spaces and comments
w:{x@&{:[(*x)_in s;0;"/"=*x;1=#x;1]}'x:(&11>t\c x)_ x:" ",x _dv"\r"}

D:`plus`minus`times`dividedby`and`or`less`more`equal`power`mod`match`join`take`drop`form`find`at`dot
M:`flip`negate`first`reciprocal`where`reverse`upgrade`downgrade`group`shape`enumerate`not`enlist`count`floor`format`unique`atom`value
DMA:$D,M,`each`over`scan`eachprior`eachright`eachleft
dma:(,:'v),(v,'":"),(,:'a),a,'":"

q:{:[(*|x)_in v;1;"_"=*x;2<#x;0]}  / verb?
/ parse monadic verbs [vla]v[^ra] and remove silent :'s
p:{c:*:'x:w x;d:{(*|x)_in v}'x;e:c=":"
 x[i]:x[i:&d&(-1_1,d|({("_"=*x)&2<#x}'x)|e|c _lin l,a)&~b:1_(c _lin"[;\n",r,a),1],'":"
 -1_,/{((DMA,,x)dma?x)," "}'x _di&b&e&~-1_1,c _lin l}

p"x++y"
p"1_'(&x=y)_ y:x,y"

\
:`"([{;}]) gets back quote paren bracket brace semi [close close close]
todo: '... \... :...  signal trace return and system commands