/ edit distances(add/del/chg) from x to all substrings of y

x:"as"
y:"awash"

/ minimum of (add)min(del)min(chg?)
d0:{:[~#x;0;~#y;#x;(1+_f[x;-1_ y])&(1+_f[-1_ x;y])&_f[-1_ x;-1_ y]+~(*|x)=*|y]}
d1:{:[~#x;#y;~#y;#x;(1+_f[x;-1_ y])&(1+_f[-1_ x;y])&_f[-1_ x;-1_ y]+~(*|x)=*|y]}
d0["as"]'(!6)#\:y
/ 2 1 1 1 0 1 e.g. edit distance for "as" to string "" is 2

/ vector rewrite
p0:{{z(1+&)\(1_ x)&(-1_ x)-y}/[&1+#y;x=\:y;1+!#x]} /partial
p1:{{z(1+&)\(1_ x)&(-1_ x)-y}/[!1+#y;x=\:y;1+!#x]} /total
p0[x;y]

/ faster rewrite
r0:{w+{&\z,(1+1_ x)&(-1_ x)-y}/[-w:!1+#y;x=\:y;1+!#x]}
r1:{(!1+#y)+{&\z,(1+1_ x)&(-1_ x)-y}/[&1+#y;x=\:y;1+!#x]}
r0[x;y]

x:"ctagc"	/ amino acid pattern
y:"tgac" 100000 _draw 4

\t r0[x;y]
