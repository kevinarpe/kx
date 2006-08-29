/ d:1:`d;.:'1:`l	/ map database and recover log
d:10 _draw 10

w:!0		/ empty client list

.m.g:{w,:_w;d}	/ return data
.m.c:"w@:&~w=_w"	/ retain clients
.m.s:{. x;w 3:\:x;}	/ (log `l 5:,x) apply and broadcast

\m i 1     listen on port 1

\
_w is who sent the message(0 is self).
clients get the latest state.

tcp/ip implementations handle about 2000 messages per second.
group updates and star configure to boost throughput.
use .m.u(and .m.s) to control access.

client/server(tcp/ip) in k can be very simple.
server listens; clients connect and send strings to execute, e.g.

h:3:`,1		/ connect to localhost port 1
h 3:"v:1 2 3"	/ set remote v to 1 2 3
h 4:"v+2"	/ get v+2 remote

default behavior can be overwritten by setting
.m.g    / get callback
.m.s    / set callback
.m.c    / close callback
.m.u    / user access list
