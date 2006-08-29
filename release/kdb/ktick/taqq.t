load'tdb/rtdb.t'

/ sample analytics

\signum:{[x] (0<x)-0>x}  / -1,0,1

/ sample queries
\Q:("# analyze all ticks for a day"
 "select last price, sum size by sym from trade"
 ""
 "# analyze all ticks for a symbol"
 "select last price, sum size from trade where sym='IBM'"
 ""
 "# everything: count by exchange"
 "select count$ by ex from trade"
 ""
 "# downticks, noticks and upticks"
 "select count$ by signum[deltas price] from trade where sym='IBM'"
 ""
 "# hour rollups"
 "select last price, sum size, count$ by time.hh from trade where sym='IBM'"
 ""
 "# 10 minute rollups"
 "select last price, sum size by hhmm 10*floor time.hhmm/10 from trade where sym='IBM'"
 ""
 "# moving signal, e.g. price< .99 of the 5 tick moving average"
 "select from trade where sym='IBM', price<.99*5 avgs price"
 ""
 "# 7 best stocks to hold over interval"
 "7 first desc select last price, (last price)/first price by sym from trade"
 ""
 "# 3 worst hours for some stock"
 "3 first asc select (last price)/first price by time.hh from trade where sym='IBM'"
 ""
 "# best single buy then sell for IBM"
 "select max price - mins price from trade where sym='IBM'")
