/ ------------------------------------------------------------------------------
/ 2002-01-31    Eberhard Lutz  XHTML 1.0 parser
/
/ This is an extended version of the xml.k parser written by Arthur Whitney
/
/ For a feature description see also: xhtml.txt
/ ------------------------------------------------------------------------------

/ xml: (tag;data|xml+;(attr;value)*)  dtd: element(,|?+*) attlist entity

\d .xml

PI:"<?xml version='1.0' encoding='ISO-8859-1'?>"
DT:("<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/strict.dtd'>"
    "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
    "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Frameset//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd'>")

DTD:0   / default: 0 strict     1 transitional      2 frameset

/ ISO-8859-1 entities
ent:$`nbsp`iexcl`cent`pound`curren`yen`brvbar`sect`uml`copy`ordf`laquo`not`shy`reg`macr`deg`plusmn`sup2`sup3`acute`micro`para`middot`cedil`sup1`ordm`raquo`frac14`frac12`frac34`iquest`Agrave`Aacute`Acirc`Atilde`Auml`Aring`AElig`Ccedil`Egrave`Eacute`Ecirc`Euml`Igrave`Iacute`Icirc`Iuml`ETH`Ntilde`Ograve`Oacute`Ocirc`Otilde`Ouml`times`Oslash`Ugrave`Uacute`Ucirc`Uuml`Yacute`THORN`szlig`agrave`aacute`acirc`atilde`auml`aring`aelig`ccedil`egrave`eacute`ecirc`euml`igrave`iacute`icirc`iuml`eth`ntilde`ograve`oacute`ocirc`otilde`ouml`divide`oslash`ugrave`uacute`ucirc`uuml`yacute`thorn`yuml`quot`amp`lt`gt`apos`OElig`oelig`Scaron`scaron`Yuml`circ`tilde`ensp`emsp`thinsp`zwnj`zwj`lrm`rlm`ndash`mdash`lsquo`rsquo`sbquo`ldquo`rdquo`bdquo`dagger`Dagger`permil`lsaquo`rsaquo`euro`fnof`Alpha`Beta`Gamma`Delta`Epsilon`Zeta`Eta`Theta`Iota`Kappa`Lambda`Mu`Nu`Xi`Omicron`Pi`Rho`Sigma`Tau`Upsilon`Phi`Chi`Psi`Omega`alpha`beta`gamma`delta`epsilon`zeta`eta`theta`iota`kappa`lambda`mu`nu`xi`omicron`pi`rho`sigmaf`sigma`tau`upsilon`phi`chi`psi`omega`thetasym`upsih`piv`bull`hellip`prime`Prime`oline`frasl`weierp`image`real`trade`alefsym`larr`uarr`rarr`darr`harr`crarr`lArr`uArr`rArr`dArr`hArr`forall`part`exist`empty`nabla`isin`notin`ni`prod`sum`minus`lowast`radic`prop`infin`ang`and`or`cap`cup`int`there4`sim`cong`asymp`ne`equiv`le`ge`sub`sup`nsub`sube`supe`oplus`otimes`perp`sdot`lceil`rceil`lfloor`rfloor`lang`rang`loz`spades`clubs`hearts`diams
max:|/#:'ent  / max length of &entity; string (for comparison)
/ numerical equivalents
num:160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 34 38 60 62 39 338 339 352 353 376 710 732 8194 8195 8201 8204 8205 8206 8207 8211 8212 8216 8217 8218 8220 8221 8222 8224 8225 8240 8249 8250 8364 402 913 914 915 916 917 918 919 920 921 922 923 924 925 926 927 928 929 931 932 933 934 935 936 937 945 946 947 948 949 950 951 952 953 954 955 956 957 958 959 960 961 962 963 964 965 966 967 968 969 977 978 982 8226 8230 8242 8243 8254 8260 8472 8465 8476 8482 8501 8592 8593 8594 8595 8596 8629 8656 8657 8658 8659 8660 8704 8706 8707 8709 8711 8712 8713 8715 8719 8721 8722 8727 8730 8733 8734 8736 8743 8744 8745 8746 8747 8756 8764 8773 8776 8800 8801 8804 8805 8834 8835 8836 8838 8839 8853 8855 8869 8901 8968 8969 8970 8971 9001 9002 9674 9824 9827 9829 9830

ce:{:[256>n:num@ent?x;,_ci n;1!";&",x]}                     / char from entity
ec:{1!";&",:[(#num)>n:num?x;ent@n;"#",$x]}                  / entity from character

join:{(#x)_(0#x),/x,/:y}    / cut:{:[#y;(#x)_'(y _ss x)_ y:x,y;()]}

X:{16_sv(_ic "0123456789ABCDEF")?/:_ic[x]-32*(~x<"a")&~x>"f"} / hex conversion
ed:{ec 0$3_-1!x}        / entity from decimal representation
eh:{ec X 4_-1!x}        / entity from hexadecimal representation
/ &entity; from &#decimal; or &#xHexadecimal; numerical reference
en:{_ssr/[x;("&#x??;";"&#x???;";"&#x????;";"&#??;";"&#???;";"&#????;");(3#eh),3#ed]}
cx:{if[~#i*:(max+2)>j:(e:(i:&x="&")_ x)?\:";";:x]           / char from xml
  k:(v:1_'((i@j:&(1_'j#'e)_lin ent)_ x))?\:";"
  ((*i)#x),/(ce'k#'v),'(1+k)_'v}
xc:{if[#i:&"&"=x;a:i@&~k:(#:'l)>j:(l:i _ x)?\:";"   / xml from char
  if[#a,:(i@&k)@&~((1_'j#'l)@&k)_lin ent;x:((*a)#x),/"&amp;",/:1_'(a@:<a)_ x]]
  x:_ssr/[x;"\"'<>";("&quot;";"&apos;";"&lt;";"&gt;")]
  :[#i:&159<_ic x;x:((*i)#x),/(ec'_ic*:'v),'1_'v:i _ x;x]}
ex:{(&b&1=+\(b&:~e)-(c&1!">"=x)|e:(b:"<"=x)&1!c:"/"=x)_ x}  / element from xml
nc:{x _di{x+!3+y-x}.'m@!*^m:+x _ss("<!--";"-->")}           / no <!-- comments -->
/ isolate all key-value pairs of the form key='value' --> (`key;"value")
kv:{if[~#x;:()];m:+({`$-1_(m*(-#x)<m:-(|x)?" ")#x}'-1_(0,i:1+&"="=x)_ x
 {:[2>"'\""?*x;1_(1+(1_ x)?*x)#x]}'(i:1+&x="=")_\:x:" ",_ssr/[x].+((" =";"=");("= ";"=")))
 ,(+/(+\3+#:',/'$m)<#x)#m:m _di?(&`~'m[;0]),&_n~'m[;1]}
/ select the successor of a bracket z from a list x, return the last pos y if not found
sb:{:[#a:(+/z>x)_ x;*a;y]}
/ tag unbound text  text --> <@>text</@>
tt:{co:{(+\-1_0,#:'x)+(*&:)'x}(oo:&(o:"<"=x)&~1!s:"/"=x)_ c:">"=x;a:-1+#x
  e:(&o&~-1!c)_dvl oc@i:&(sb[oo;m]'co)>oc:sb[&o&1!s;m:-1+#x]'co:co _dvl(&c&-1!s)
  b:1+(&c&~1!o)_dvl co@i;a:(0,i@<i:b,e)_ x;a[i]:"<@>",/:(a@i:&(!#a)!2),\:"</@>";:,/a}
/ special tags for inline code <%proc%> <--> <_>proc</_>
pp:{_ssr/[y].+:[x;|:';(),](("<%";"<_>");("%>";"</_>"))}
/ (s;v[;a]) from xhtml  <@>text</@> --> (`;"text")
dx:{if["/>"~-2#x;x:(-2_ x),"></",(1_(&/x?/:" /")#x),">"];x:_ssr[x;" >";">"]
 a:(1+m:s?" ")_ s:(n:x?">")#x
 (:["@"=*s:1_ m#s;`;`$s];:["<"=*x:(1+n)_(-m+2)_ x;_f'ex x;cx x]),kv a}
/ xhtml from (s;v[;a])  collapse <br></br> --> <br /> for unforgiving browsers
xd:{v:x 1;:[#s:$*x;"<",s,:[2=#x;"";,/" ",'{($*x),"='",(*|x),"'"}'x 2],:[4:v;:[#v;">",v:xc v;""];">",v:,/_f'v],:[#v;"</",s,">";" />"];xc v]}
ss:{@[x;&x _lin"\t\r\n";:;" "]}     / whitespace
xs:{x -1_&|':0,~" "=x," "}          / remove extra blanks
indent:{s:1+y?">";e:-1-(|y)?"<";:[~"<"=*t:s _ e _ y;,x,y;(,x,s#y),(,/_f[" ",x]'ex t),,x,e#y]}[""]
DX:{dx tt pp[0]@,/r@&~(r:(&b&1=+\(b:r="<")-r=">")_ r:_ssr[;"> <";"><"]xs ss en nc x)[;1]_lin"?!"}
XD:join["\n"](,PI),(,DT[DTD]),indent pp[1]xd@

\

s:"<a attr='value'>head &nbsp;<b>&lambda;</b>center &copy;<c/><d e='f' g='h'>tail</a>"
t:DX s
t
XD t
