hlcv:([sym:()])

/ view hlcv select high:max price,low:min price,last price,sum size by sym from trade

\upd:{[t;x].d.r("hlcv:select max high,min low,last price,sum size by sym from 
    (()key hlcv)union select sym,high:price,low:price,price,size from ?";x)}

\(`;2011)3:"sub`trade"
