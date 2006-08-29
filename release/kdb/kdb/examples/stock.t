/ portfolio analytics (stocks)

ndays:2000 # eight years
ncusips:500
nsplits:1000
dates:reverse date['2000-06-01']-asc ndays

industry:('internet','hardware','software','finance','auto')

cusip:([cusip:asc (-ncusips)rand'   ']
 shares:100*100+ncusips rand 100,
 industry:ncusips rand industry)

n:ncusips*ndays
t:([cusip:cusip.cusip])cross([date:dates])
\t.cusip..S:1
t.price:50+n rand 50.0
t.volume:100*n rand 100

split:([cusip:nsplits rand cusip.cusip,date:nsplits rand dates]
 adj:nsplits rand(1.5,2.0,3.0))

/ split/dividend adjust
't'union split
update adj:prds 1 fill adj by cusip from't'
update adjprice:price*adj from't'

/
say we have a portfolio
create a temp column called value, which is for date_i:
value(date_i) =  Sum( Holding(x)*Price(x,date_i)  +  ... +
then create (and benchmark the execution time)
20 day moving average of value
20 day historical volatility of value
20 day moving correlation of value with IBM's price.
autocorrelation of value
\

/ portfolio; buy and hold; reinvest dividends
n:10
portfolio:([cusip:(-n)rand cusip.cusip]shares:10*1+n rand 4)

/ analytic dates and tracking cusip
pdates:70 last dates
pdate:first pdates
cusip1:rand portfolio.cusip

/ calculate adjusted(original) shares
update adjshares:shares/t[cusip,pdate].adj from'portfolio'

/ select relevant data
:u:select cusip,date,adjprice from t where cusip in portfolio.cusip,date in pdates

/ calculate value on all dates (dot product)
:r:select value:portfolio[cusip].adjshares sum adjprice by date from u

/ escape to k to define analytic routines
/ moving averages,variances,deviations,covariances,correlations
\avgs:{[n;x] x-(-n)_(((n-1)#0n),0.0),x:+\x%n}
\vars:{[n;x] avgs[n;x*x]-a*a:avgs[n;x]}
\devs:{[n;x] _sqrt vars[n;x]}
\covs:{[n;x;y] avgs[n;x*y]-avgs[n;x]*avgs[n;y]}
\cors:{[n;x;y] covs[n;x;y]%devs[n;x]*devs[n;y]}

m:20 # moving window  
/ moving averages; moving volatilities
:update mval:m avgs value, mvol:devs[m,log ratios value]*sqrt 253 from'r'

/ moving correlation with tracking cusip
update price1:u[cusip1].adjprice from'r'
update mcor:cors[m,value,price1] from'r'

\autocorrelation:{(+/*':x)%+/x*x-:(+/x)%#x}
/(sum timesprior x)divided by sum x times x minus gets average x

autocorrelation r.value
