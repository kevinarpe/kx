/ simple timer, e.g.   \t 1 then .t..t:"t"

/ timers:  S(strings) T(times) A(absolute) R(repeat)
/ e.g. .t..A[_t+10;"t"] or .t..R[3;"t"]

\d .t.

S:()
T:()
A:{[t;s] @[`.t.;`T`S;{(x#y),(,z),x _ y}[.t..T _bin 1+t];(t;s)];} 
R:{[t;s] .t..A[_t+t;s,";t..A[_t+",($t),";.t..Z]"];}	/ string only
t:"while[~t<*t..T,2000000;t..Z:*.t..S;@[`t.;`T`S;1_];:[4:t..Z;. t..Z;.[.;t..Z]]]"

\t 1
