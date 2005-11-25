"
http://inferno.bell-labs.com/cm/cs/who/bwk/interps/pap.html

this is a benchmark investigating 
scripting languages - perl, awk, tcl, scheme - and
interface-building languages - limbo, vb and java.

the 9 tests are loops, text-processing and stdio.
[we really are different. we avoid all these. a full 
 implementation of an RDBMS is a better benchmark.]

even though k is not designed for 

 loops -- rare in k-applications, e.g. none in kdb
 text-processing -- we prefer data-processing -- binary is better
 stdio -- we prefer mmap to read/write

k is faster (sum of times)
 k(32) perl(95) java(300) tcl(1400+)
 [k is much faster than c on strings and memory management.]

k is shorter (lines of code)
 k(9) awk(66) perl(96) tcl(105) scheme(170) vb(200) java(350)";

/ do one million increments on initial state 0
\t 1000000(1+)/0

/ ackermann's
\t {:[~x;y+1;~y;_f[x-1;1];_f[x-1;_f[x;y-1]]]}[3;7]

/ array indexed forwards and backwards
\t x(x;|x:!200000)	

/ while(x>count string) join chop join ... on "abcdef"
f:{(x>#:){(i _ x),(1+i:_.5*#x)#x:,/("123";x;"456";x;"789")}/y}
\t do[10;f[500000;"abcdef"]]

/ lookup hex strings in decimal strings
\t {+/("0123456789abcdef"16_vs'!x)_lin$!x}40000
 
`f 0:(30000 _draw 300)#\:"king "	/ james

/ write read stdio
\t `f 0:0:`f	

/ (lines;words;chars)stdio
\t (#:;+/(+/1<':" "=)';+/#:')@\:0:`f 

/ write reverse read stdio
\t `f 0:|0:`f  		

`f 0:100000#,"-123.456"	/ some numbers

/ sum float-from-ascii stdio
\t +/0.0$0:`f  	

\del f

/ approximate times on 100MHZ pentium (32MB)
t:(2 10 .15 2.2 1 3.5 3.2 4 5.7		/k
 .3 1 .8 5 25 80 50 125 15		/java
 3 40 8 1 6 4 15 8 10.			/perl
 100 1000 100 20 12 80 15 70 50.)	/tcl
+/'t

\
\t {`show$,$i:0;do[x;s0,:$i+:1]}800  		/ gui text