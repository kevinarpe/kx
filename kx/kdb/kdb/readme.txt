http://kx.com/a/kdb/document for documentation and release notes.
http://kx.com/a/kdb/examples for sample servers.
http://kx.com/a/kdb/connect for sample clients.

UNIX/LINUX unzip kdb.zip -d $HOME/k
WINDOWS/NT kdbsetup.exe installs C:\k

k/sp.s trade.t		sql and ksql sample scripts
k/db/s.txt t.txt 	sql and ksql quick reference

kdb has two query languages:($ to switch)
 sql	odbc/jdbc default	sql92
 ksql	http/kdbc default	sql+timeseries

kdb has two stored procedure languages, c and k,
but many applications can be done entirely with ksql.

server:  k db trade.t -P 2080	# listen for HTTP on port 2080
client:  http://localhost:2080/.xml?select sum amount by stock from trade

unlimited data. unlimited users. in general,

k db [f] [-p n] [-P n] [-d] [-D] [-e] [-f] [-l] [-n] [-N n] [-o] [-r[h]p] [-s] [-S n]

  f script(.s,.t), data+log(.kdb) or directory
 -p KDBC-port ODBC JDBC
 -P HTTP-port XML CSV TXT HTML
 -d display incoming messages
 -D display viewer
 -e error trap for production servers
 -f full precision float text export
 -l log update messages to .kdb (implies -e)
 -n nulls ignored by aggregation(ansi-sql)
 -N http maximum number of rows
 -o readonly
 -r replicate asynchronously to [host]port
 -s shuffle/map on demand (implied by parallel)
 -S slaves for parallel 

\\ to exit

Evaluation version has size and message limit.
Use scripts(.s .t), jdbc, odbc and flat files to build databases.
