/ http://www.kuro5hin.org/story/2002/6/25/122237/078
/ find one-letter change paths for the following

x:(`make`love;`bread`wheat;`resist`futile;`effaces`cabaret
   `wood`fire;`climb`rocks;`stones`chisel;`amperes`voltage)

/ words grouped by count
\t W@:8#{((=x),,!0)u?/:!1+|/u:?x}@#:'W:0:"word.lst"

/ graphs from equivalence classes of one-letter deletes `an`in<`n<`an`in
\t G:{(?,/@[n#,!0;x;,;!n:#x]@)'x:+{x?/:x:26 _sv 1_ x}'(1!)\_ic+x}'W

/ f-path to x from y http://kx.com/a/k/examples/graph.k  (f-path to x from y)
p:{[f;x;y]:[#*y:|{(#y)&~x _in y}[x]{_dvl[?,/f x]v,:x}\y,v::();x{y@*&x _in/:f y}\1_ y;()]}

/ wrapper
W:`$W;P:{W[n] p[G[n]]. W[n:#$*x]?/:x}
\t P'x

/ cache results
A:B:();C:{:[(x@:<x)_in A;B A?x;*|B,:,P@*|A,:,x]}
\t C't,|:'t:x,x,x,x

\
	lines	sec(1.47GHZ)
K	4	.8
C++	375	3
C#	425	45
Java	431	10

