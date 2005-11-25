2004.04.13 >k taq2 SRC	/ split among par.txt
2003.12.22 >k taq2 SRC	/ loads new ftp

http://www.nyse.com/marketinfo   TAQ database CD's

HARDWARE
 O/S: solaris, linux or winNT/2000(A/S) (pagefile.sys>=2GB)
 ram: 2GB(min 1GB)	cpu:900MHZ+  
 disk: 10000rpm+ scsi (connect: 40MB+ U160,FCAL,Gbit ethernet,...)
 data: 22billion+ trades and quotes (50GB+ per month. 1.5TB back to aug1993.) 
 speed: timeseries and rollups of millions of records per second.

INSTALL (get k.lic and taq.zip from tech@kx.com)
 install k and kdb from http://kx.com/download
 put k.lic in $HOME/k and unzip taq.zip -d $HOME/k (or C:\k)
 make k/dst.txt with directory path(DST), e.g. /export/0
 make taq/par.txt, e.g. 

/export/1/taq
/export/2/taq
..
/export/n/taq

 put daily TAQ FTP (or monthly dvd data: (*.tab *.idx *.bin)) in SRC
 >k taq2 SRC [-split]           / load ftp from SRC to DST/taq (split among par.txt)
 >k taq SRC                     / load dvd from SRC to DST/taq

 >k db DST/taq -p 2010 -P 3010  / (re)start and view with http://HOST:3010

MAINTENANCE  load TAQ DVD's once per month and/or load TAQ FTP every night
 
NOTES
 DST is one level up from taq. code installed in $HOME/k
 to load just trades(or quotes) only put t*.* in SRC
 
CLIENT http://kx.com/a/ktdb/client.txt for java, vb and c clients

SCHEMA http://www.nyse.com/pdfs/userguid.pdf
 trade:([]date,sym,time,price,size,cond,ex)
 quote:([]date,sym,time,bid,ask,bsize,asize,mode,ex)
 mas:([sym,date]name,cusip,...) / master table
 div:([sym,date]div,adj)        / additive adjustments

QUERY	put http://kx.com/a/ktaq/q.t in $HOME/k
 ksql>load'q.t'

 1 million prices per second per drive(at 10,000 ticks per sym per day)
 10ms(6seek+4read) * (days/drives) * selectfields * syms, e.g. 10*1*3*2 milliseconds for
 select vwap:size avg price by sym from trade where date=d0,sym in('IBM','MSFT')

ADJUST	put http://kx.com/a/ktaq/adj.t in $HOME/k  (split, dividend and symbol change)
 ksql>load'adj.t' 
 ksql>r:select last price by mas:m sym,date from trade where sym in s[('HPQ','XOM')]
 ksql>update ret:(price+adm[date,mas].adj)/prev price from 'r'

 m - master from [date]sym
 s - symbol from [date]mas

 master is the last sym by cusip. date is an implicit parameter.

SPEED

1. query time is roughly proportional to data read. read as little as possible.
   restrict dates, syms and fields as much as possible, e.g.

 select date,time,price from trade where sym='IBM'   is twice as fast as
 select from trade where sym='IBM'

2. move as little data as possible. calculate in the server.

 select size avg price by date from trade where sym='IBM'  is a lot faster than
 java: r=vwap(k("select date,price,size from trade where sym='IBM'));


