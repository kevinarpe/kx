/ JDBC dr. dobb's jan/98 pp. 82

$create table t(
 i int primary key,
 m varchar(20),
 b int,
 x float,
 p char(30),
 d date)

n:10000
't'insert(asc n,n rand'',n rand 10,n rand 10000.0,n rand'',n rand 365)

/ stored procedure
\p:{t[`x;y:t[`i]?y]:x;t[;y]:(5;`name;10;2000.0;`password;.d.ds"1997-08-29")}

/save'ddj.kdb'
\\m i 2001
\

/ raw
\s:"select * from t where i < 10000 and x < 10000.0"
\u0:.d.mm["update t set x=? where i=?";(2000.0;5)]
\u1:"insert into t values(5,'name',10,2000.0,'password',date'1997-08-29')"

\\t do[100;.d.r s]
\\t do[100;.d.insert[`t]t]
\\t do[100;.d.r u0;.d.r u1]
\\t do[100;p[2000.0;5]]
\
timings for jdbc-typeIV drivers.(NT4.0 sybase sql-server 11.0)
 
size syb(700K+) kdb(50K)	 connect syb(1.1) kdb(.1) 

1. static/dynamic[i,x] select
2. static/dynamic[i,x] bulk upsert(jdbc doesn't do bulk)
3. static/dynamic[i,x] update/delete/insert 
4. static/dynamic[i,x] stored procedure update.

number of records(60Bytes) per second:

        *1(read)    *2(write)   3(scalar write) 4(procedure)
ddj(1)    100                   25/20           50/20
kdb(2)
 kdbc   30000       15000       55              250
 jdbc   15000			55		250
 odbc
raw   800000       600000       125             2200


*bulk is much faster than record by record.(gated by network)
kdb preparse, index etc. would make record/write faster.

(1) 200MHZ 24MBclient/32MBserver 10Mbit ethernet
(2) 450MHZ (assume 1MB network)


