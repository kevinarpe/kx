k connect

non-k processes can call k as a subroutine or remote server.
k can dynamically load non-k routines and talk to non-k servers.

c.class		java k-client(package k)
k.xls		excel script	
k.bas		vb/excel module
[declare function k lib"k20"(s,paramarray a())]

bc.kr		bond calculator(us govt)
bc.java		java client

java, vb and excel make good front-ends for
k analytic and data servers because all share
the same basic self-describing datatypes.
single entry point: k(string[,x,y...])		/ execute string [and apply]

java calls a server(e.g. k -i 2001); vb/excel use the dll, e.g.,

java:		k.c c=new k.c("",2001);c.k("+",new Integer(2),new Double(3.4));
vb/excel:	k("+",2,3.4) (excel: =k("+",a1,a2))
 
loading scripts, e.g. avg:{(+/x)%#x}	in  c:\k\stat.k
java:		c.k("\\l stat");int[]a={2,3,4};Double f = c.k("avg",a);
vb/excel:	k"\l stat";k("avg",Array(2,3,4)) (excel: =k("avg",a1:a3))

datatype

k         java      vb/excel
1(int)    Integer   Long
2(float)  Double    Double
3(byte)   Byte      Byte
4(sym)    String    String
6(null)   null      Null

list      array     array
0         Object[]  Variant()
-1        int[]     Long()
-2        double[]  Double()
-3        byte[]    Byte()
-4        String[]  String()

signal    throw     Error

Date goes to k julian integer.
Time and Timestamp go to float.

excel:	scalars are float, sym or date. ranges are matrices.

k has primitives for data extraction from large files.
the k.dll(.so .sl etc. on UNIX) has an entry point for
registering socket callbacks, e.g. for reuters triarch.
we have an odbc connection, sybase bcp extraction etc..