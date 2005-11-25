/ copyright(c) 1997 kx systems
/ enhanced by mkr

nfl..c:`form

nfl..a:`Who`Quarterback`Rating

\d nfl
 
Blanda: 4007 1911 26920 236 277   / george blanda
Montana: 4600 2929 35124 244 123  / joe montana
Whitney: 800 620 10000 95 0	  / arthur whitney

Who:.+(`Blanda`Montana`Whitney;(3#,"Who..l:_i"))
Who..c:`button
Who..l:`Blanda

Quarterback..d:".+(`Attempts`Completions`Yards`Touchdowns`Interceptions;. Who..l)"

Rating..d:"+/0|39.6&-25 -12.5 0 39.6+83.3 4.17 333.3 -416.7*{(1_ x)%*x}Quarterback[]"

\d ^

`show$`nfl