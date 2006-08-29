clients can use jdbc, odbc, kdbc and http to read/write data.

where possible we recommend kdbc since it is

faster:   k("insert",t,bulk) can be 10,000 times faster
simpler:  result=k("select ...")
better:   result=k("func",arg0,arg1,...)

see http://kx.com/a/kdb/connect/kdbc.txt

jdbc/odbc are ok for aggregation queries
since the server is doing most of the work.

the default language of jdbc/odbc is sql92.
the kdbc default is ksql. use $ to switch.

see end of k/db/s.txt (part of download) for sql92 exceptions.

kdb is TRANSACTION_SERIALIZABLE only.
kdb is autocommit, i.e. put complex/batch transactions in procedures.
kdb has static cursors. entire result-set comes across.
odbc/jdbc metadata: (sql/get)typeinfo,tables,columns,primarykeys,foreignkeys