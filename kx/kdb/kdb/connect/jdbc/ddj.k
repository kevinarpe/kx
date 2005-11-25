/ kdb client

h:3:`,2001			/ connect to server

/ dynamic select
s:("$select * from t where i<? and x<?";(10000;10000.0))

/ dynamic update
u:(("$update t set x=? where i=?";(2000.0;5))
    "$insert into t values(5,'name',10,2000.0,'password',date'1997-08-29')")

\t t:h 4:s			/ select 10000
\t h 4:(`insert;(`t;t 1))	/ insert 10000
\t do[100;h 4:'u]		/ updates
\t do[100;h 4:(`p;(2000.0;5))]	/ stored procedure update


\
 .3
 .6
1.7
 .4