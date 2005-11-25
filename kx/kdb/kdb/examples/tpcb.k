/ client
/ apply and log 100,000 transactions

n:100000

h:3:`,2001		/ connect to server

t.account:123456789+567*n _draw -1000000

t.teller:n _draw 10000

t.branch:n _draw 100

t.qty:-100+200*n _draw 0

t.status..f:`ok`rollback`@
t.status:n#2

g..l:"group commit"
g:1000	/ 25 millisecond ack

go..c:`button
go:"{t.status[i]:h 4:`up,,t[`account`teller`branch`qty;i:x+!g]}'g*!_ n%g;"

.k..l:`transactions
.k..a:(`go`g;`t)
`show$`.k

\

each transaction ...

[ai,ti,bi,qty]
 if 0>x+(select qty from account where id=ai) then rollback
 update account set qty=qty+x where id=ai
 update teller set qty=qty+x where id=ti
 update branch set qty=qty+x where id=bi
 commit
