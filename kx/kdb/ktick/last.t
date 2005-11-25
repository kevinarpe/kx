trade:([sym:()]price:0.0)

/ bring client up-to-date
\(`;2011)3:"sub`trade"

/ alert for stocks where price> previous price
\upd:{[t;x]\.d.r("select sym,price from ? where price>trade[sym].price";x);.d.insert[t;x]}
