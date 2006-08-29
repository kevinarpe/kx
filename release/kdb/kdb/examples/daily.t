/
tick data is partitioned by date and sorted by symbol(or master).

daily data should be sorted and indexed by master.
the master column should be an enumeration into the master table.
for convenience the key of the master should be the current ticker.
the data should be partitioned by year if more than 33 million rows.
e.g. more than 13000 securities over 10 years
the number of columns doesn't matter. there can be hundreds.
adjprice (splits and dividends) can be stored (rewrite data on update)
or calculated on the fly. (e.g. http://kx.com/a/ktaq/adj.t)

queries:  ... where [year=2002,] mas=?, ... (cross-section: mas in ?)
are 1 to 10 milliseconds per sym*partition*field depending on mem/disk.
 
daily update, sort, index and adjustment recalc is about 1GB/minute.
\

/ master table
n:1000
mas:([sym:(-n)rand'    ']cusip:(-n)rand'')
'daily'save'mas'

/ two years of weekdays
date:select from([date:date['2001-01-01']+asc 730])where 5>date%7
a:date cross([mas:mas mas.sym]);n:count a
update price:n rand 100.0,volume:n rand 100 from'a'
s:rand mas.sym

t:select from a where date.year=2001;'mas'asc't';'mas'index't'
'daily/2001'rsave't'
t:select from a where date.year=2002;'mas'asc't';'mas'index't'
'daily/2002'rsave't'
\q:"select last price by date.month from t where year>=current_date.year-5,mas=s"
'daily'save('s','q')

\

 
/ kdb 2002-12-02 or later
\upd:{f:`":daily/2002/t";.d.r(`insert;(f;x));.d.r(`asc;(`mas;f));.d.r(`index;(`mas;f));.d.load`daily}
n:count mas
x:(n take current_date,asc n,n rand 100.0,n rand 100)
:upd x

\
update copy of database and then switch servers
