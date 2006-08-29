/ index calculations

/ keep last prices only
trade:([sym:()])

\upd:.d.insert

\(`;2011)3:"sub`trade"

/ some indices
u:([indx:(0,1)]sym:(('MSFT','IBM'),('MSFT','INTC','IBM')),wgt:((3,7),(2,3,4)))

view v update value:wgt avg each trade[sym].price from u
