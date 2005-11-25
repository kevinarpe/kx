fn:100		# first names
ln:200		# last names
n:fn*ln		# personnel

lastname:asc ln rand'      '
firstname:asc fn rand'     '
branch:('air force','army','navy','marine')
mrank:('general','colonel','private')
state:('alabama','alaska','arizona','arkansas','california','colorado','connecticut','delaware',
 'florida','georgia','hawaii','idaho','illinois','indiana','iowa','kansas','kentucky','louisiana',
 'maine','maryland','massachussets','michigan','minnesota','mississippi','missouri','montana',
 'nebraska','nevada','new hampshire','new jersey','new mexico','new york','north carolina','north dakota',
 'ohio','oklahoma','oregon','pennsylvania','rhode island','south carolina','south dakota',
 'tennessee','texas','utah','vermont','virginia','washington','west virginia','wisconsin','wyoming')

:person:([ssn:100000000+n rand -900000000]
 lastname:n rand lastname,
 firstname:n rand firstname,
 branch:branch at n skew(3,5,4,1),
 mrank:mrank at n skew(1,10,100), 
 state:n rand state)

person:'lastname'asc person

ln:first person.lastname
fn:first person.firstname

:select from person where lastname=ln, firstname=fn		# uses sort
:select from person where firstname=fn, lastname=ln
:select count$ by mrank from person

n:10
lang:('spanish','french','chinese','japanese','russian','german')
u:([]ssn:n rand person.ssn,lang:n rand lang)
