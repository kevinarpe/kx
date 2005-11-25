\H:"suppliers-and-parts, cf. A Guide to the SQL Standard"

create table s(
 s char(5) primary key,
 name char(20),
 status int,
 city char(15))

create table p(
 p char(6) primary key,
 name char(20),
 color char(6),
 weight int,
 city char(15))

create table sp(
 s char(5) references s,
 p char(6) references p,
 qty int,
 primary key(s,p))

insert into s values('s1','smith',20,'london')
insert into s values('s2','jones',10,'paris')
insert into s values('s3','blake',30,'paris')
insert into s values('s4','clark',20,'london')
insert into s values('s5','adams',30,'athens')
insert into p values('p1','nut','red',12,'london')
insert into p values('p2','bolt','green',17,'paris')
insert into p values('p3','screw','blue',17,'rome')
insert into p values('p4','screw','red',14,'london')
insert into p values('p5','cam','blue',12,'paris')
insert into p values('p6','cog','red',19,'london')
insert into sp values('s1','p1',300)
insert into sp values('s1','p2',200)
insert into sp values('s1','p3',400)
insert into sp values('s1','p4',200)
insert into sp values('s4','p5',100)
insert into sp values('s1','p6',100)
insert into sp values('s2','p1',300)
insert into sp values('s2','p2',400)
insert into sp values('s3','p2',200)
insert into sp values('s4','p2',200)
insert into sp values('s4','p4',300)
insert into sp values('s1','p5',400)

\Q:("select from sp where s.city = p.city"
 "$select sp.s, sp.p, sp.qty from sp, s, p where sp.s = s.s and sp.p = p.p and s.city = p.city"
 ""
 "distinct select p, s.city from sp"
 "$select distinct sp.p, s.city from sp, s where sp.s = s.s")

\

/ pp13
insert into sp(s, p, qty)values('s5','p1',1000)
update s set status = 2 * status where city = 'london'
delete from p where weight > 15

/ pp146 
select p.p, p.weight, p.color, max(sp.qty) from p, sp
 where p.p = sp.p and p.color in ('red','blue') and sp.qty > 200
 group by p.p, p.weight, p.color having sum(sp.qty) > 350
