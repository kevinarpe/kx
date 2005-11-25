/ suppliers-and-parts, cf. A Guide to the SQL Standard

s:([s:('s1','s2','s3','s4','s5')]
 name:('smith','jones','blake','clark','adams'),
 status:(20,10,30,20,30),
 city:('london','paris','paris','london','athens'))

p:([p:('p1','p2','p3','p4','p5','p6')]
 name:('nut','bolt','screw','screw','cam','cog'),
 color:('red','green','blue','red','blue','red'),
 weight:(12,17,17,14,12,19),
 city:('london','paris','rome','london','paris','london'))

sp:([s:('s1','s1','s1','s1','s4','s1','s2','s2','s3','s4','s4','s1'),
     p:('p1','p2','p3','p4','p5','p6','p1','p2','p2','p2','p4','p5')]
 qty:(300,200,400,200,100,100,300,400,200,200,300,400))

\Q:(""
 "select by p, s.city from sp"
 "$select distinct sp.p, s.city from sp, s where sp.s = s.s"
 ""
 "select by color, city from p where weight > 10, city <> 'paris'"
 "$select distinct color, city from p where weight > 10 and city <> 'paris'"
 ""
 "select from sp where s.city = p.city"
 "$select s.s, p.p, sp.qty from s, p, sp where sp.s = s.s and sp.p = p.p and p.city = s.city")

\
/ enumerated version
color:('blue','green','red')
city:('athens','london','paris','rome')

s:([s:('s1','s2','s3','s4','s5')]
 name:('smith','jones','blake','clark','adams'),
 status:(20,10,30,20,30),
 city:city('london','paris','paris','london','athens'))

p:([p:('p1','p2','p3','p4','p5','p6')]
 name:('nut','bolt','screw','screw','cam','cog'),
 color:color('red','green','blue','red','blue','red'),
 weight:(12,17,17,14,12,19),
 city:city('london','paris','rome','london','paris','london'))

sp:([s:s('s1','s1','s1','s1','s4','s1','s2','s2','s3','s4','s4','s1'),
     p:p('p1','p2','p3','p4','p5','p6','p1','p2','p2','p2','p4','p5')]
 qty:(300,200,400,200,100,100,300,400,200,200,300,400))

\
/ cjdate/shasha problem
select p by s from select asc s by p from sp