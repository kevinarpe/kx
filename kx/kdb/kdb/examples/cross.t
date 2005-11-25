/ timeseries and indices

nd:1000	# number of days
ni:1000	# number of issues
n:nd*ni	# number of rows in the timeseries table

/ issue indicative table
issue:([issue:(-ni)rand'   ']name:ni rand'',sector:ni rand' ')

d:date['2000-01-01']-nd	# start date
i:rand issue.issue	# an issue

/ timeseries table with n rows
t:([date:d+asc nd])cross([issue:issue.issue])

/ insert some columns
t.price:n rand 1.0
t.volume:n rand 100

/
without indices kdb searches 10 Million RPS per cpu.
(put most restrictive constraint first.)

there are two ways to enable fast subset lookup:
(1 millisecond instead of n*.0001 millisecond.)

1. asc (no space required), e.g. 'date'asc't'
2. index (4*n bytes), e.g. 'issue'index't'

the asc/index is used by the first constraint

... where f = ... , ... (also: within, in)

and with ksql scalar indexing, e.g. t[date'1999-12-10',].price

a table can have one sorted column and many indices.
don't bother indexing tables with fewer than 100,000 rows.
the index is currently optimized for repeats.
indices serve no purpose for table scans or any 
query that hits every page(cacheline) on disk(memory).
\

'date'asc't'	# date asc
'issue'index't'	# issue index

n:1000		# some queries
\\t do[n;.d.r"select avg price from t where date=rand date"]
\\t do[n;.d.r"select avg price from t where issue=rand issue"]
\\t do[n;.d.r"avg t[d,].price"]
\\t do[n;.d.r"avg t[,i].price"]

/ these all take roughly the same amount of time
:select avg price from t where date within(d,d+30)
:select avg price from t where date in d+asc 31
:select avg price from t where date.month=d.month

show''