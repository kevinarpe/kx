Attribute VB_Name = "Module1"
Declare Function k Lib "k20" (s, ParamArray a())

' connect to a server, e.g.:  k db sp.s -p 2001
'  h=kdbopen("//localhost:2001")
'
'
' tables are returned as Array(names,columns), e.g.
'  t=kdb(h, "select sum qty by s.city from sp")
'  ?t(0)(0)            is city
'  ?t(1)(0)(0)         is london
'  ?t(1)(1)(0)         is 2200
'
' results are atoms, lists, dictionaries or tables.
'
' queries can be parameterized with arbitrary data, e.g.
'  kdb(h, "select sum qty from sp where s.city = ?","london"))

Function kdbopen(d)
kdbopen = k("3:(`;0)$$:", Split(Mid(d, 3), ":"))
End Function

Function kdb(h, q, ParamArray a())
kdb = k("4:", h, Array(q, a))
End Function

Sub kdbclose(h)
k "3::", h
End Sub

