k is good for data and analytic servers.

k runs on LINUX, NT and UNIX.

design goal: speed
 write fast, run fast, modify fast.
 minimize product of vocabulary and program size.

examples: [java, vb and c++ require 4 to 400 times as much code.]

1.	"hello world"

2.	maximum subsequence sum, cf. "programming pearls", jon bentley

	f:|/0(0|+)\		/ max OVER 0 init (0 max plus)SCAN

	f 2 1 -4 2 -1 5

3.	spreadsheet, cf. http://java.sun.com/applets/SpreadSheet

	S..t:"S[.;`f]:.[`D;(;);{. y};S[]][]"	/ trigger: re-evaluate

	S:D:.+(`a`b`c`d;4 5#,"");`show$`S	/ initialize and show

	the eight hundred and forty lines of java code do less.

4.	BDT, cf. "one factor option model ..." Black, Derman, Toy

	bdt:{[p;v] bn:{.5*+':0,x,0}			/ binomial step function
	 l:(-1+%%':p)*_exp v*(2*!:'x+1)-x:1_!#p		/ generate approximate lattice
	 l:{x:bn x;x%1+y*(+/x%1+y*)?z}\[,*p;l;1_ p]	/ fit wtd-discount exactly
	 (*l){x%bn y}':l}				/ wtd-disc to forward

	bdt[*\3#%1.1;.1]

	sixty sixty-period arbitrage-free lattices per second. (200MHZ pentium)

5.	simple web-server(k -h 80)

	.m.h:{\x;"<html><body>hello world</body></html>"}	/ display message x

	http://localhost

applications are written faster and run faster. 
the more complex the application the greater the gain.
