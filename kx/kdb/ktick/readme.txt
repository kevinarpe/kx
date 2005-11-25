KDB/TICK 2.6t

tickerplant, realtimeDB, historicalDB, alerts, ...

HARDWARE (e.g. US equities trades and quotes approx 60million per day)
 O/S: solaris, linux or windows
 ram: 8GB+	cpu: 4  (more ram and cpu for alert clients)
 disk: 4GB per day 10000rpm+ scsi or SAN (connect: 40MB+ U320,FCAL,Gbit network,...)
 data: trades and quotes, e.g. taq(cts cqs ntds lvl1), level2(nqds), futures, options(opra), fips, ...
 feed: reuters(triarch/tibco ssl4.0), bloomberg, custom(java or c)
 speed: 100,000 records per second
 client: java and c: http://kx.com/a/ktick/client.txt

NB: each tickerplant should collect no more than 1GB(see -n par below)

INSTALL (get k.lic and tdb.zip from tech@kx.com)
 install k and kdb from http://kx.com/download
 put k.lic in $HOME/k and unzip tdb.zip -d $HOME/k (or C:\k)
 make k/dst.txt with r/w directory path DST for historicDB.
 put many rows in dst.txt if collecting more than 1GB
 /home/0
 /home/1
 ...

TEST HARDWARE(see http://kx.com/a/kdb/document/test.txt) 
 >cd DST
 o/s:   !:'40#17000000 (blow out workspace) then \w
 tcp:   h:3:(`server;port) then  \t do[10000;h 4:"23"]
 disk:  \t `v 1:!25000000  then  \t do[1000;`v 3:!1000]
 
 ...
 make k/tdb/TDB.t for your schema and feed or, FOR EXAMPLE, USE taq.t:
 tdb.zip has sample tickerplant scripts: taq.t, sym.t, lvl2.t, ...
 and sample realtime asynchronous clients: rtdb.t, vwap.t, hlcv.t, ...
 edit taq.t to load your feed handler, e.g. \\l tdb/taqssl
 put list of symbols in taq.txt, e.g. http://kx.com/a/ktick/sp500.txt
 [if using REUTERS/Solaris put http://kx.com/a/ktick/ssl.so in k/tdb]

>k tdb tdb/taq.t -p 2011 -l -s 18:45  / tickerplant: port 2011; log; save at 18:45
>k db tdb/rtdb.t -p 2012 -P 3012      / realtimeDB:  view http://HOST:3012
>k db tdb/vwap.t -p 2013 -P 3013      / vwapDB:      view http://HOST:3013

 at 18:45 the tickerplant updates historicDB, deletes log and exits.
 restart the historical database with:

>k db tdb/taqh.t -p 2010 -P 3010      / historicDB: view http://HOST:3010

>crontab http://kx.com/a/ktick/cron.txt

ARCHITECTURE

  [files] > historicDB:2010 > query clients (view http://host:3010)
               /
 feed(s) > tickerplant:2011 > alert clients
               \
            realtimeDB:2012 > query clients (view http://HOST:3012)	     

 processes can be on any machine. messaging is tcp/ip.

OPTIONS

>k tdb tdb/TDB.t [-p p] [-t t] [-l] [-o o] [-s hh:mm] [-d DST] [-n par]
 load TDB.t;port p;log DST/TDB.yyyymmdd;offset o hours;save at hh:mm;timer 1 sec

 -n sets the partition(row of par.txt in DST/db). for multiple tickerplants.
 no tickerplant should collect more than 1GB
../db/par.txt
/home/0/db
/home/1/db
..

>k tdb db.t -n 0 -p 6000
>k tdb db.t -n 1 -p 6001
..

have the feeds send data according
to sym, e.g. a-d e-j k-r s-z

LOCATIONS

for world-wide capture run multiple tickerplants and db's, e.g. in new york:

>k tdb tdb/usa.t -p 2011 -o  0 -s 18:10		/syms in usa.txt
>k tdb tdb/eur.t -p 2021 -o  5 -s 18:10		/syms in eur.txt
>k tdb tdb/jap.t -p 2031 -o 13 -s 18:10		/syms in jap.txt
...

each storing localtime. a gateway server can access all of them.

RESTART/LOGS
 the log is 'DST/TDB.yyyymmdd'. restart is the same as start.
 to run yesterday's log, (e.g. disk full error) >k tdb tdb/TDB.t -l yyyymmdd
 DO NOT run this command on today's log. a subsequent tickerplant would rewrite.
 DO NOT run this command while tickerplant is running. too much memory required.

MAINTENANCE  
 possible daily modification of subscriptions, e.g. k/tdb/taq.txt

NOTES
the tickerplant is the only essential process. (no queries. no gui.)
put calculations in the queries and realtime subscribers. 
design subscribers to suit the analytics.
we recommend capturing and storing raw data.
calculate on the fly in clients, queries and gateway servers.

>k tdb/taq.k     runs tickerplant, rtdb and vwap (also sym.k lvl2.k ...)

http://kx.com/a/ktick/feed.txt for java and C feeds
http://kx.com/a/ktick/alert.txt for alert-subscribe clients
http://kx.com/a/ktick/client.txt for java and C query clients

we can run multiple subscribers (rtdb.t vwap.t hlcv.t ... )
we can run multiple tickerplants (taq sym lvl2 opra futures euro fips ...)

 taq - trades and quotes US equities, e.g. IBM.N SPY.A MSFT.O ...
 sym - trades and quotes for arbitrary symbols, e.g. IBM.N SPH1 ...
 lvl2 - nasdaq level2 bids and asks, e.g. MSFT INTC DELL ...

taq is designed to match http://kx.com/a/ktaq (US equities only)

the tickerplant receives updates from a feed, logs to disk,
publishes to subscribers and updates the kdb historical database 
at the end of the day. the default heartbeat is 1 second.

tickerplant subscribers can get subsequent(sub) or all(sub1).
the realtimeDB(rtdb.t) is a simple client that offloads queries.

databases can have c and ksql analytics (vwap, bars, least squares, ...)
every kdb database has a built-in webserver. use -P P for the http port.
realtime feeds can be added quickly (1-5 days)
historic files can be added quickly (1-5 days)

[make k/log.txt with r/w directory path LOG] else DST

LIMITS
historicDB's have no limit. e.g. 10,000,000,000 taq records back to 1993.
tickerplants and realtimeDB's use 2 times as much memory as raw data and
up to 4 times as much address space. i.e. store 800MB raw data(25M rows).
a 1GHZ cpu can:
 insert about 100,000 records per second.
 parse about 10,000 records per second.
 message about 10,000 times per second.
(all 2003 US equities trades and quotes are about 1000 per second.)

some feed handlers (e.g. reuters) will disconnect if the queue gets
too big. e.g. 10 seconds at peak. therefore the tickerplant must
not block for more than a few seconds. the tickerplant must be allocated 
enough memory(and cpu) to keep up with the data (avoid swap).
if necessary dedicate a machine. (e.g. run tickerplant and realtime
on 2 cpu machine with 4GB of memory. and no other major processes.)

sub1 also blocks the tickerplant. so a late-connecting sub1 pulling
200MB of data could also cause a disconnect. if necessary introduce
an intervening buffering feedhandler, e.g. a/ktick/sym1.k (and sym1.t)

RELEASE
2002-09-22  subsequent(h 3:"sub[]") all(upd .'+h 4:"sub1[]")
2002-07-29  fractional second timer, e.g. -t .5 (requires k2.93 or later)

CORPORATE ACTIONS (SYMBOLS, CUSIPS, SPLITS and DIVIDENDS)

 store raw data and chain on the fly, http://kx.com/a/ktaq/adj.t
 e.g.,   select price from trade where sym=s['XOM']
 gives the exxon chain. every day the sym that matches today's XOM is used.
 the alternative -- maintaining 'master' -- is extremely difficult and expensive.
 here we just store the raw data and manage small mapping tables
 of symbol changes, splits and dividends.
 (there can also be sym/cusip maps for bringing in cusip based data)

 of course we can dump an entire 'master' database anytime we want.

