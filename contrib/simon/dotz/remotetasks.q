/ submit remote tasks and local tasks - synchronously or asynchronously,
/ results passed back to TASKS in this task 
/ rxa - Remote eXecute Async
/ rxs - Remote eXecute Sync
/ lxa - Local eXecute Async
/ lxs - Local eXecute Sync
/ it would be a good idea to have -g 1 set, perhaps calling .Q.gc[] after big cleanups (.z.pc?)

\l dotz.q	
@[value;"\\l remotetasks.custom.q";::];      
if[not`TASKS in system"a";
	.tasks.LASTNR:10000;
	TASKS:([nr:`int$()]grp:`symbol$();id:`int$();startp:`timestamp$();endp:`timestamp$();w:`int$();ipa:`symbol$();status:`symbol$();expr:();result:())]
TASKNRS::exec nr from TASKS
TASKGRPS::distinct exec grp from TASKS

\d .tasks
getnrsforgrps:{exec nr from`TASKS where grp in x}
setgrpfornrs:{[grP;nR] update grp:grP from`TASKS where nr in nR;nR}
nextnr:{:.tasks.LASTNR+:1}
clean:{if[count w0:exec w from`TASKS where not .dotz.liveh0 w,status=`pending;
        update endp:.z.p,w:0Ni,status:`fail from`TASKS where w in w0];
    if[AUTOCLEAN; delete from`TASKS where status<>`pending,endp<.z.p-.tasks.RETAIN];}

/ if client has gone, or the request is no longer pending don't execute
/rxagXEQ:{if[$[.z.w in key .z.W;z({x in .tasks.pending[]};x);0b];neg[.z.w]$[first result:@[{(1b;enlist value x)};y;{(0b;enlist x)}];(`.tasks.complete;x;1_ result);(`.tasks.fail;x;1_ result)]];}
/ execute async requests regardless
/rxagXEQ:{[x;y;z] neg[.z.w]$[first result:@[{(1b;enlist value x)};y;{(0b;enlist x)}];(`.tasks.complete;x;1_ result);(`.tasks.fail;x;1_ result)];}
/ if the client has gone away don't bother to execute the request
rxagXEQ:{[x;y;z] if[.z.w in key .z.W;neg[.z.w]$[first result:@[{(1b;enlist value x)};y;{(0b;enlist x)}];(`.tasks.complete;x;1_ result);(`.tasks.fail;x;1_ result)]];}

rxsgXEQ:{$[first result:@[{(1b;enlist value x)};y;{(0b;enlist x)}];(`.tasks.complete;x;1_ result);(`.tasks.fail;x;1_ result)]}
lxagXEQ:{neg[.z.w](`.tasks.localexecute;x);neg[.z.w][];}
lxsgXEQ:{localexecute x}

addtask0:{[nr;w;grp;id;expr;zp]
    `TASKS insert`nr`grp`id`startp`endp`w`ipa`status`expr`result!(nr;grp;id;zp;0Np;w;`;`pending;expr;()); nr}
addtask:{[nr;w;grp;id;expr;zp]
    $[.dotz.liveh w;clean[];'"invalid handle"];
    addtask0[nr;w;grp;id;expr;zp]}

rxagz:{[w;grp;id;expr;zz] addtask[nr:nextnr[];w:abs w;grp;id;expr;zz];neg[w](rxagXEQ;nr;expr;.dotz.HOSTPORT);neg[w][];nr}    
rxag:{[w;grp;id;expr] rxagz[w;grp;id;expr;.z.p]}    
rxa:{[w;expr] rxag[w;`;0;expr]}

rxsgz:{[w;grp;id;expr;zz] addtask[nr:nextnr[];w:abs w;grp;id;expr;zz];value w(rxsgXEQ;nr;expr);nr}    
rxsg:{[w;grp;id;expr] rxsgz[w;grp;id;expr;.z.p]}    
rxs:{[w;expr] rxsg[w;`;0;expr]}

lxagz:{[w;grp;id;expr;zz] addtask[nr:nextnr[];w:abs w;grp;id;expr;zz];neg[w](lxagXEQ;nr);neg[w][];nr}    
lxag:{[w;grp;id;expr] lxagz[w;grp;id;expr;.z.p]}    
lxa:{[w;expr] lxag[w;`;0;expr]}

lxsgz:{[w;grp;id;expr;zz] addtask0[nr:nextnr[];w:abs w;grp;id;expr;zz];value(lxsgXEQ;nr);nr}    
lxsg:{[w;grp;id;expr] lxsgz[w;grp;id;expr;.z.p]}    
lxs:{[w;expr] lxsg[w;`;0;expr]}
lxs0:lxs 0

results:{ exec result by nr from`TASKS where status=`complete,nr in x}
resultsf:{$[all x in completed[];results x;'`missing.tasks]} / force results

ms:{0.000001*ns x}
ns:{exec`long$endp-startp by nr from`TASKS where nr in x}
status:{exec status by nr from`TASKS where nr in x}

completed:{exec nr from`TASKS where status=`complete}
failed:{exec nr from`TASKS where status=`fail}
cancelled:{exec nr from`TASKS where status=`cancel}
pending:{exec nr from`TASKS where status=`pending}

checkwfornr:{{x!@[;"1b";0b]each x:distinct x}exec w from`TASKS where .dotz.liveh0 w,nr in x}
cancel:{update status:`cancel,endp:.z.p from`TASKS where status=`pending,nr in x;x}
reset:{delete from`TASKS;}

/ callbacks

pc:{[result;W] update w:0Ni from`TASKS where w=W; clean[]; result}

/ saveonexit:{[result;arg] clean[];if[count value`TASKS;(`$":T",(-9_(string .z.p)except"D:."),".",(string .z.i),".csv")0:","0:update pid:.z.i from select nr,grp,id,startp,ns:`long$endp-startp from`TASKS where status=`complete];result}
saveonexit:{[result;arg] result} / by default don't do anything interesting

\d .
.tasks.complete:{[nR;resulT] TASKS::update result:resulT,endp:.z.p,status:`complete,ipa:.dotz.ipa .z.a from TASKS where nr=nR;}
.tasks.fail:{[nR;resulT] TASKS::update result:resulT,endp:.z.p,status:`fail,ipa:.dotz.ipa .z.a from TASKS where status=`pending,nr=nR;}
.tasks.localexecute:{[nR] 
	if[not null ti:first exec i from TASKS where nr=nR,status=`pending;
		r:@[{(1b;enlist value x)};first exec expr from TASKS where i=ti;{(0b;enlist x)}];
		statuS:`fail`complete[first r];	
		TASKS::update result:1_r,endp:.z.p,status:statuS,ipa:.dotz.ipa .z.a from TASKS where i=ti];}

.z.pc:{.tasks.pc[x y;y]}.z.pc
.z.exit:{.tasks.saveonexit[x y;y]}.z.exit                                           
