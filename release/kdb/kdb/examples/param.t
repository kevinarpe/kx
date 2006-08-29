/
kdb2.2 "?"'s just support scalars, e.g.

.d.r("select from t where date within(?,?)";(x;y))

kdb2.3 allows list and table parameters, e.g.

.d.r("select from ? where f in ?";(table;list))
\

load'trade.t'

/ two stocks
s:('xx','yyyy')

\f:{[s]
 .d.r("select last price by stock from trade where stock in ?";,s)}

f[s] 
