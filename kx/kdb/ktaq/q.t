D:2 take date
S:('A','AA')
d:first D
s:first S

/ national best bid and ask
\eb:{[e;b]|/(=e){(0.0,y x)@&-':0,x,#y}\:b}
\ea:{[e;a]&/(=e){(1e9,y x)@&-':0,x,#y}\:a}
\eb[e:0 1 1 0;b:7 7 6 5.0]
/ total size at the inside
\ebs:{[e;b;s]+/((0,'s i)@'j)*b=\:|/b:(0.0,'b i)@'j:(&-':0,)'(i:=e),'#e}
\eas:{[e;a;s]+/((0,'s i)@'j)*a=\:&/a:(1e9,'a i)@'j:(&-':0,)'(i:=e),'#e}

q:update ask:ask+1e9*not ask from select from quote where date=d,sym=s,0<asize+bsize
b:select time,bid:eb[ex,bid],bsize:ebs[ex,bid,bsize],ask:ea[ex,ask],asize:eas[ex,ask,asize]from q
\differ:~0=':  / just keep the changes
c:select from b where(differ bid)or(differ bsize)or(differ ask)or differ asize

/ rollup and merge 5 minute intervals. fraction at inside quote
t0:'09:30';t1:'10:00'
q:select last bid,last ask by sym,hhmm 5*5 floor time.hhmm from quote where date=d,sym in S,not time<t0,time<t1
t:select size,price,          sym,hhmm 5*5 floor time.hhmm from trade where date=d,sym in S,not time<t0,time<t1

r:([sym:sym S])cross([hhmm:hhmm[t0]+2*asc 15])
q:update bid:fills prev bid,ask:fills prev ask by sym from q union r
select size avg(price<q[sym,hhmm].bid)or price>q[sym,hhmm].ask by sym,hhmm from t

/ analytics
\signum:{[x] (0<x)-0>x}  / -1,0,1
/ queries
\Q:("# analyze all ticks for a day"
 "select last price, sum size by sym from trade where date=d"
 ""
 "# analyze all ticks for a symbol"
 "select last price, sum size by date from trade where sym='IBM'"
 ""
 "# everything: count by exchange"
 "select count$ by ex from trade"
 ""
 "# downticks, noticks and upticks"
 "select count$ by signum[deltas price] from trade where sym='IBM'"
 ""
 "# hour rollups"
 "select last price, sum size, count$ by date, time.hh from trade where sym='IBM'"
 ""
 "# 10 minute rollups"
 "select last price, sum size by date, hhmm 10*10 floor time.hhmm from trade where sym='IBM'"
 ""
 "# moving signal, e.g. price< .99 of the 5 tick moving average"
 "select from trade where sym='IBM', price<.99*5 avgs price"
 ""
 "# 10 best stocks to hold over interval"
 "10 first desc select last price, (last price)/first price by sym from trade where date=d"
 ""
 "# 7 worst hours for some stock"
 "7 first asc select (last price)/first price by date, time.hh from trade where sym='IBM'"
 ""
 "# best single buy then sell for IBM"
 "select max price - mins price from trade where sym='IBM'")
