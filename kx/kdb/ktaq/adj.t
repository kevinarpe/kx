/ dividend, split and symbol adjustments (can put in DST/taq)

/
taq ftp and dvd's come with mas(symbol) and div(dividend and split) adjustments.
(this information is incomplete and can be added to in this script.)
since this data can change every day we store the original sym and price
and apply adjustments on the fly. (millions per second)
intraday calculations, e.g. returns, do not require adjustment.
the taq adjustments are additive -- multiplicative is easier.
(split seems to be taqadj%previous close(primary exchange midpoint))
adjustments use small change tables and binary search functions.

sm:([mas,date]sym) / symbol from master (current symbol)
sm can handle mergers as a surviving company. e.g. XOM 19991201 XON (MOB stops)
\

/ calculate sm from mas by cusip
sm:'cusip'asc'date'asc select from mas where not null date,not null cusip,not wi
sm:select mas:(select last sym by cusip from sm)[cusip].sym,date,sym from sm
sm:select from(select mas,next date,sym from sm)where sym<>mas,sym<>next sym
('mas','date')key'sm'
/ 'sm'insert  ... your data .... ([mas,date]sym)  'mas'asc'date'asc
/ d0:first date;sym0:sym;sm:select from sm where date>d0, sym in sym0
update sym sym from'sm'

/ functions for day adjustments (.1million per second)
\ftdx:{[f;t;d;x]:[x _in u:*t;t[2;i]t[1;i:u?x]_bin d;f x]}
\ft:{[f;t]ftdx[f;(u;t[1;i]-1;t[2;i:=*t],'f'u:?*t)]'}
\sdm:ft[{sym?x}]sm[]
\mds:ft[{sym@x}]@|sm[;<sm`sym]
adm:('date','mas')key select date,mas:mds[date,sym sym],adj:div+adj from div

/ functions for intraday adjustments (10million per second)
\fx:{[f;x]:[@x;f x;f[u](u:?x)?/:x]} / apply f to uniques
\s:fx[{sdm[trade[`date]0]x}]
\m:fx[{mds[trade[`date]0]x}]

\
/ example: from 2000-10
x:('HPQ','NLI','RY') / (split;NTLI;split/div)
r:select last price by mas:m sym,date from trade where date.month='2000-10',sym in s x
r:select size avg price by mas:m sym,date from trade where date.month='2000-10',sym in s x
update r:(price+0 fill adm[date,mas].adj)/prev price by mas from 'r'
/(lastp+adj)/prev lastp   is close to:   (vwap+adj)/prev vwap