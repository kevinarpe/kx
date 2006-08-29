/ step through this script with:  \s incdec
/ press buttons, resize window and change values ...

v:0					/ a value

inc:"v+:1"			/ increment expression

dec:"v-:1"			/ decrement expression

inc..c:`button		/ display class

dec..c:`button		/ display class

`show$`.k			

v:!1000000				/ million values

.k..a:(`v;`inc`dec)		/ rearrange display

v:+\1 -1[1000 _draw 2]	/ random walk

v..c:`chart				/ display class

n:1000					/ parameterize

v..d:"+\\1 -1[n _draw 2]"	/ dependency

.k..a[1],:`n			/ rearrange

