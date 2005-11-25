k)comb:{(,!0){,/(|!#y),''y#\:1+x}/x+\\(y-x-:1)#1}
/ d - date 
/ st, et - start time, end time 
/ gt - granularity type `minute `second `hour .. 
/ gi - granularity interval (for xbar)
/ s - symbols
pcorr:{[d;st;et;gt;gi;s]
	data:select last price by sym,gi xbar gt$time from trade where date=d,sym in s,time within(st,et);
	us:select distinct sym from data;ut:select distinct time from data;
	if[(count data)<(count us)*count ut; / if there are data holes..
		filler:first 1#0#exec price from data;
		data:update price:fills price from`time xasc(2!update price:filler from us cross ut),data];
	PCORR::0!select avgp:avg price,devp:dev price,price by sym from data;
	data:(::);r:{.[pcorrcalc;;0]PCORR x}peach comb[2]count PCORR;PCORR::(::);r} 

pcorrcalc:{[x;y]`sym0`sym1`co!(x[`sym];y[`sym];(avg[x[`price]*y[`price]]-x[`avgp]*y[`avgp])%x[`devp]*y[`devp])}

\
d:first date;st:10:00;et:11:30;gt:`second;gi:10;s:`GOOG`MSFT`AAPL`CSCO`IBM`INTL
show pcorr[d;st;et;gt;gi;s]
