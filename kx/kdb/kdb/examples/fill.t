/ to form timeseries we may need fill

t:([stock:('a','a','b','b','b'),date:(1,2,0,2,3)]
 price:(1,2,3,4,5),amount:(5,4,3,2,1))

/ rack
r:(distinct select stock from t)cross distinct select date from t

/ upsert
'r' insert t

/ forward fill price
update price:fills price by stock from 'r'

/ 0 fill amount
update amount:0 fill amount from 'r'

\f:{[stock]
 t:.d.r("select stock,date,price from t where stock in ?";,stock)
 r:.d.r("([stock:?])cross distinct select date from ?";(stock;t))
 .d.r("update fills price by stock from ? insert ?";(r;t))}


f[('b','a')]