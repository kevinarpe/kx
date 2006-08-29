/ given: k tdb tdb/lvl2.t -p 2021

nqds:([sym:(),mmid:()])

\upd:.d.insert

\(`;2021)3:"sub[]";
 
\cat:{.(. x),. y}
view MSFT cat['bid'desc(select mmid,bsize,bid from nqds where sym='MSFT'),
              'ask' asc(select ask,asize,mmid from nqds where sym='MSFT')]

