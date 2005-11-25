calc..a:(`exp
   `va`vb`vc`vd
   `n0`n1`n2`n3
   `n4`n5`n6`n7
   `n8`n9`lp`rp
   `fa`fs`fm`fd`fe
   `eval`clear)

calc:@[_n;1_-1_ calc..a;:[;"exp,:(~_v)`l"]]	/ expressions

calc[.;`l]:"abcd0123456789()+-*%:"		/ labels

calc.eval:"exp:5:. exp"

calc.clear:"exp:\"\""

calc[.;`c]:`button

calc.exp:calc.exp..l:""

`show$`calc
\e 0
\c 0
 