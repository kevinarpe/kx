\d .h
jx:{[j;x]N:(*."\\C")-4;$[$[.Q.qt[x];N<n:#x;0];(" "/:ha'["?[",/:$(0;0|j-N),|&\(n-N;j+N);$`home`up`down`end],,($n),"[",($j),"]";"");()],,htbl .q.sublist[j,N]x} 

htbl:{g:{(#*y)#'(,,"<",x),y,,,"</",x:($x),">"};
	,/htac[`table;(,`class)!,"striped"](htc[`thead]htc[`tr]@,/htc[`th]'$!x),htc[`tbody]@,/,/'+g[`tr]@,/`td g',:'$. x:+0!x}   

sa:htac[`style;(,`type)!,"text/css"]"@import 'doth.css';"
sb:htac[`script;`type`src!("text/javascript";"jquery.js")]""
sc:htac[`script;`type`src!("text/javascript";"doth.js")]""
html:{htc[`html]htc[`head;sa,sb,sc],htc[`body]x}
fram:{htc[`html]htc[`head]htc[`title;x],htac[`frameset;(`frameborder`cols)!("no";($116|316&43+(7+"?"~*z)*|/#:'y),",*")]@,/hta[`frame]'((,`src)!,*z;`name`src!`v,,*|z)}

/ remove next line when change released to q.k
HOME:"";hm:{`$":",$[#HOME;HOME;"html"],"/",x}; /GET /[r.{txt|csv|xml}]?..  or ?[J   / Refresh: 3

.z.ph:{x:uh$[@x;x;*x]
 $[   ~#x;hy[`htm]fram[$.z.f;x]("?";"?",*x:$."\\a")
	"?"=*x;html@,/$[~#x:1_x;htbl([]table:{hb["?",x]x}'$."\\a");"["=*x;jx["J"$1_x]R;jx[0j]R::. x]
  "?"in x;hy[t]@`/:tx[t:`$-3#n#x]@.(1+n:x?"?")_x
  "."in x;$[0>@!x:hm x;hy[`$|(x?".")#x:|$x]"c"$1:x;hn[x],"\r\n",x:"404 Not Found"]
  hn[x],"\r\n",x:"400 Bad Request"]}

