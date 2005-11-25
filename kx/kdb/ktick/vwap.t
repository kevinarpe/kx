/ view vwap select size avg price by sym from trade

v:([sym:()]size:(),value:())

\upd:{[t;x].d.r("'v'+select sum size,value:size sum price by sym from ?";x)}

\(`;2011)3:"sub`trade"

view vwap select sym,vwap:value/size from v

/... by sym, hhmm 10*floor time.hhmm/10 ...

