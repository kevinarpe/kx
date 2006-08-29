/ find avg salary through time given
/ employee salary. 0 indicates termination.

kx:([]
 year:(1066,1688,1789,1215,1492,1806,1947,1542,1776,1901,1600,1800,2035),
 name:('arthur','arthur','arthur','joel','joel','joel','joel',
       'stevan','stevan','stevan','wayne','wayne','wayne'),
 salary:(1,2,0,2,3,5,8,9,0,9,3,4,5))

'year'asc'kx'  # natural order

update raise:0 deltas salary, event:0 deltas 0<salary by name from 'kx'

update avgsal:(sums raise)/sums event from 'kx'

/ sums raise is total salary to date
/ sums event is total employees to date

\

/ merge intervals where avgsal doesn't change
delete from ... where 0=deltas avgsal

/ start-end representation
t:([]s:(1,2,3),e:(2,3,4),x:(6,8,7))
't'asc select sum x by t from(select t:e,-x from t)union select t:s,x from t
