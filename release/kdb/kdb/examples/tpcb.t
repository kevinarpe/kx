/ tpcb >50,000 transactions per second

q:100000000.0 # quantity

n:1000000
account:([id:123456789+567*asc n]qty:n take q/n)

n:10000
teller:([id:(-n)rand n]qty:n take q/n)

n:100
branch:([id:(-n)rand n]qty:n take q/n)

delete q,n

/ stored procedure for group commit
/ rollback insufficient funds
/ apply others

\up:{[ai;ti;bi;x]
  i:account[`id]_binl ai
  if[|/r:0>account[`qty;i]+x   / group rollback
   i@:j:&~r;ti@:j;bi@:j;x@:j]
  account[`qty;i]+:x
  teller[`qty;teller[`id]?/:ti]+:x
  branch[`qty;branch[`id]?/:bi]+:x
  r}

\\m i 2001
\
save'tpcb.kdb'