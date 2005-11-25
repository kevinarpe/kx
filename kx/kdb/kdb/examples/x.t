'examples'
/ generate table of historic yield curves for each date/curr pair
t:([date:date['1998-01-01']+asc 7]) cross ([curr:('usd','dem')])
t.curve:(14,6)rand 10
show't'

/web sessions(shasha@cs.nyu.edu)  
/sequence of hits from client within 1 minute of previous.
n:10
hit:([]timestamp:sums n rand 60/86400, client:n rand 2)
update start:1<60*24*-0i deltas timestamp by client from 'hit'
show'hit'

/ quartiles(michaelr@lehman.com)
n:12
u:([id:asc n]price:n rand 100)
show'u'

'lowest price quartile?'
select from u where 0 = 4 rank price

'lowest 4 prices?'
select from u where 4 > rank price

/ best month(s) by product 
v:([product:('a','b','c')]) cross ([month:asc 12])
v.value:(count v)rand 100
select from v where value=max value by product

