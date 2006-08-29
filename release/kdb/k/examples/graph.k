t:0 0 1	 / tree
t\2	/ transitive closure

d:(();,0;0 7;,1;1 2;,2;,4;,8;,9;()) / dag

(?,/d@)\,4     / transitive closure
g:@[d;d;,;!#d] / graph from dag

c:{(#y)&~x _in y}  / check for termination
a:{[f;x]x(~f x@)(1+)/0} / first x such that f x
b:{[f;x;y]:[#*y:|y;x{a[x _in f@]y}\1_ y;()]}	/ back to y from x

/ f-path to x from y (back to y from breadthfirst search to y from x)
D:{[f;x;y]b[f;x] c[x](?,/f@)\,y}
G:{[f;x;y]b[f;x] c[x]{_dvl[?,/f x]v,:x}\y,v::()} / maintain visited v

D[d;0;4]
G[g;5;3]
\

/ dag all paths
f:{:[#r:d x;,/x,''_f'r;,x]}
f 6

/ matrix  graph from dag:  m|+m
f: |/&(connect) &/+(shortest) +/*(count) +/&(capacity) ...
matrix O(n*n^2) f\:(or m f/:\:+m) closure in log2[n] steps
vector O(n*m^2) adjacency vectors are better for sparse graphs

