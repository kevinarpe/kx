/
kdb is great with timeseries because

1. we store vectors. [kdb can store arbitrary self-describing data.]
2. we manipulate vectors. [aggregators, integrators, differentiators, ...]
3. we can easily extend the language with c, k and ksql vector functions.
4. we're fast. [several million records per second per cpu]

[some other rdbms's are also extensible, e.g. oracle8i.
 but if it takes oracle .7 millisecond per function call 
 per record then kdb is 3 orders of magnitude faster ...]

there are 3 ways to store timeseries in kdb.

1. first normal form
2. regular (matrix/pivot/xtab: one calendar)
3. irregular (ragged: one calendar per item)

advantages. (all three handle arbitrary calendars)

1. i/o to other rdbms's and ansi-sql.
2. much faster. process tens of millions of elements per second.
3. less storage for sparse data. (e.g. mortgage payments)

(2&3 don't have gui support yet. use 'each' to apply vector functions)

transform periodicity with '.' notation, e.g. date.quarter

 absolute time:	timestamp second minute hour date week month quarter half year
 periodic time:	time(of day) hhmmss hhmm hh day(of week) mth(of year) qtr hlf

some atomic functions:	
 + - * / min max fill null [bucket]floor [bucket]ceiling

some vector functions:
 aggregators:	count [weights]sum min max [weights]avg last
 integrators:	sums prds [moving]avgs [init]fills
 differentiators: [init]deltas [init]ratios
 other:			[n-tile]rank ratio reverse asc desc

examples:
\

load'trade.t'

/ daily data from raw transactions
daily:select last price by stock, date from trade

/ daily data in matrix/pivot form
daily2:select price by stock from daily

/ select data for single stock
s1:select from daily where stock='xx'

/ select data for single month 
m1:select from daily where date.month='1998M12'

/ add column of 5 day moving averages by stock
update price5:5 avgs price by stock from'daily'

/ monthly from daily
monthly:select last price by stock, date.month from daily

/ extend kdb with pairwise moving maximum external function
\maxpair:{(*x)|':x}

/ add column of maxpair price by stock
update price2:maxpair price by stock from'monthly'

\

exercises:

split adjust
dividend adjust

use the 'rack' to form calendar template
fill missing data
correlations
5-day moving average intersect 21-day

take tick data to 5 minute intervals