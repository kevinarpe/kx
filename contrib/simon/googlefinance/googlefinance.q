/ grab googlefinance stock OHLCV history

goog:{[offset;stocks] / goog[100;`GOOG`AMZN], start q with slaves to take advantage of peach
        zs:(ze:`date$.z.z)-offset;
        parms:"&startdate=",(string -1+`mm$ze),"+",(string`dd$ze),",+",(string`year$ze),"&enddate=",(string -1+`mm$zs),"+",(string`dd$zs),",+",(string`year$zs),"&output=csv";
        tbl:flip `Date`Open`High`Low`Close`Volume`Sym!("DEEEEIS";" ")0:();
        tbl,:raze{$["200"~3#9_r:httpget["finance.google.com"]"/finance/historical?q=",(string x),y;update Sym:x from select from("DEEEEI ";enlist",")0:{(x ss"Date,Open")_ x}r;z]}[;parms;tbl]peach distinct upper stocks,();
        (lower cols tbl)xcol`Date`Sym xasc select from tbl where not null Volume}

httpget:{[host;location] (`$":http://",host)"GET ",location," http/1.1\r\nhost:",host,"\r\n\r\n"} 
sp500:asc first flip` vs/: `$read0`:tick/sp500.txt

