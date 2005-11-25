/ date  (0 is monday, 2035-01-01)

md:{_.d.ed[x]%32}  / month from day
dm:{.d.de 32*x}	   / day from month
bom:{dm md x}      / beg of month
eom:{-1+dm 1+md x} / end of month
