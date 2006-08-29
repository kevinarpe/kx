// http://www.itasoftware.com/careers/programmers.php

/ first positive integer you can't make with nine 9's(and +-*%)

f:{+/j=!#j@:<j:?j@:&x=j:_ x@:&~0>x}

/ work with all
/\t a:*|8{x,,?,//x{x y/:'|x}/:(+;*;%)}/,-9 9.0

/ work with positives .5 second
\t a:*|8{x,,?,//x{x y/:'|x}/:(+;*;%;_abs-)}/,,9.0

f a

\

/ add-a-gram
s:{x@<x}'w:0:`word.lst

/ count group .05 second
\t a:s@|3_((=n),,!0)(?n)?/:!1+|/n:#:'s

/ all deletions
del:{x[;i _di/:i:!#*x]}

/ backward
d:{:[#x;y@&y _lin,/del x;x]}

/ brute force .15 second (save result)
\t {~#*r::|d\x}(1_)/a

/ forward
e:{y@*&x _in/:del y}

\t b:(**r)e\1_ r

w s?/:b
\

("aim"
 "aims"
 "amies"
 "amines"
 "anomies"
 "amniotes"
 "nominates"
 "antimonies"
 "inseminator"
 "terminations"
 "antimodernist"
 "determinations"
 "intermediations"
 "indeterminations")