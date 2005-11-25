/ snapshot in time

m:2 # number of items
n:6 # number of changes

/ date ascending change
t0:([]d:date['1999-01-01']+asc n rand 100,t:n rand m,v:n rand 100)

date:date'1999-02-15'

/ sql correlated subquery
$select t,v from t0 where d<date and 
 d=(select max(d)from t0 t1 where d<date and t0.t=t1.t)

/ ksql
select t,v from t0 where d<=date, d=max d by t

/ ksql with order (this is best)
select last v by t from t0 where d<=date

\

try to use just effective date.
use nulls to show termination.

 