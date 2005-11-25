/ generate a parallel database
/ run:  k db census -p 2001 -P 2080
/ see:  http://kx.com/a/kdb/document/parallel.txt

\\mkdir census
\\cd census

/ shared data
\citizen:hispanic:owned:`no`yes
type:('a','b','c','d')
sex:('male','female')
race:('white','black','amerind','asian','other')
education:('<9','9-12','high','college','associate','bachelor','graduate')
employment:('none','part','half','full','more')
county:-500 rand'     '
state:([state:('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA',
 'KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC',
 'ND','OH','OK','OR','PA','PR','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY')]
 name:('alabama','alaska','arizona','arkansas','california','colorado','connecticut','delaware',
  'florida','georgia','hawaii','idaho','illinois','indiana','iowa','kansas','kentucky','louisiana',
  'maine','maryland','massachussets','michigan','minnesota','mississippi','missouri','montana',
  'nebraska','nevada','new hampshire','new jersey','new mexico','new york','north carolina','north dakota',
  'ohio','oklahoma','oregon','pennsylvania','puerto rico','rhode island','south carolina','south dakota',
  'tennessee','texas','utah','vermont','virginia','washington','west virginia','wisconsin','wyoming'))
birthnation:('US','Canada','Great Britain','France')

/ sample queries
\Q:("select count$by sex,house.tract.county from person where house.tract.state='AL',age within(30,50)"
 "select avg income from person where house.tract.state='CA',hispanic"
 "select count$by sex,house.owned,race from person where house.tract.area in(0,9)"
 "select count$,avg age by birthnation,employment,sex,education from person where birthnation<>'US'")

/ save shared data
''save vars''

s:5 # scale factor (1000 for US)
an:floor s*5		#areas

/ horizontal partition saves with enumerated types
n:4 # partitions
tn:floor s*100/n	#tracts
hn:floor s*115000/n	#houses
pn:floor s*280000/n	#people

/st cou trac  area is 20 census tracts
\t:("tract:([state:tn rand count state,county:tn rand count county,tract:tn rand 100]area:tn rand an)"
 "house:([]tract:asc hn rand tn,owned:hn rand 2,type:hn rand 4)"
 "person:([]house:asc pn rand hn,sex:pn rand 2,year:1900+pn rand 100,income:pn rand 100000,
   education:pn rand count education,employment:pn rand count employment,race:pn rand count race,
   hispanic:pn skew(4,1),citizen:pn skew(1,9),birthnation:pn skew(90,2,1,1))"
 "update age:2000-year from'person'"
 "update entry:case when birthnation then year+floor age*pn rand 1.0 end from'person'")

\f:{.d.r't;tract[~f;`T]:f:`state`county;house[~f;`T]:f:`tract`owned`type
 person[~f;`T]:f:`house`sex`education`employment`race`hispanic`citizen`birthnation
 .d.r(`rsave;(x;`person`house`tract))}
\f'$!n
 
\\
person(161 fields)house(114 fields)
geographic sort: p,h,t?
20 node 4cpu 128MB; SSAdrives?
