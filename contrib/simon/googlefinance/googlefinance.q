/ grab googlefinance stock OHLCV history
/ http://finance.google.com

goog:{[offset;stocks] / goog[100;`GOOG`AMZN], start q with slaves to take advantage of peach
        zs:(ze:`date$.z.z)-offset;
		m:`Jan`Feb`Mar`Apr`May`Jun`Jul`Aug`Sep`Oct`Nov`Dec;
		parms:"&startdate=",(string m -1+`mm$zs),"+",(string`dd$zs),"%2C+",(string`year$zs),"&enddate=",(string m -1+`mm$ze),"+",(string`dd$ze),"%2C+",(string`year$ze),"&output=csv";
        tbl:flip`Date`Open`High`Low`Close`Volume`Sym!("DEEEEIS";" ")0:();
        tbl,:raze{$["200"~3#9_r:httpget["finance.google.com"]"/finance/historical?q=",(string x),y;update Sym:x from select from("DEEEEI ";enlist",")0:{(x ss"Date,Open")_ x}r;z]}[;parms;tbl]peach distinct upper stocks,();
        (lower cols tbl)xcol`Date`Sym xasc select from tbl where not null Volume}

/ fetch nasdaqdaily report
/ http://www.nasdaqtrader.com/Trader.aspx?id=DailyMarketFiles
/ http://www.nasdaqtrader.com/Trader.aspx?id=DailyMarketSummaryDefs

nasdaqdaily:{fmts:"*EEEEEEEEEEEEEEEFFFFEEE";
	hdrs:`Date`N100`Financial100`Composite`CompositeHi`CompositeLow`N100Hi`N100Low`Industrial`Bank`Insurance`Financial`Transportation`Telecom`Biotech`Computer`NasdaqTrades`Volume`DolVol`MktVal`Advances`Declines`Unchanged;
	t:hdrs xcol(fmts;enlist",")0:(1_r ss"Date")_r:httpget["www.nasdaqtrader.com";"/dynamic/dailyfiles/daily2008.csv"];
	/ correct wacko date format
	asc update Date:"D"${-8_x}each Date from t}

httpget:{[host;location] (`$":http://",host)"GET ",location," HTTP/1.1\r\nHost:",host,"\r\n\r\n"} 
sp500:asc first flip` vs/: `$read0`:tick/sp500.txt

