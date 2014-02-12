// set up the upd function to handle heartbeats
upd:{[t;x]
 $[t=`heartbeat;
  .hb.storeheartbeat[x];
  t=`logmsg;insert[`logmsg;x];
  ()]}

subscribedhandles:0 0Ni

// subscribe to heartbeats and log messages on a handle
subscribe:{[handle]
 subscribedhandles,::handle;
 @[handle;(`.ps.subscribe;`heartbeat;`);{.lg.e[`monitor;"failed to subscribe to logmsg on handle ",(string x),": ",y]}[handle]];
 @[handle;(`.ps.subscribe;`logmsg;`);{.lg.e[`monitor;"failed to subscribe to logmsg on handle ",(string x),": ",y]}[handle]];
 }
 
// if a handle is closed, remove it from the list
.z.pc:{if[y;subscribedhandles::subscribedhandles except y]; x@y}@[value;`.z.pc;{{[x]}}]

// Make the connections and subscribe
.servers.startup[]
subscribe each (exec w from .servers.SERVERS) except subscribedhandles;

// As new processes become available, try to connect 
.servers.addprocscustom:{[connectiontab;procs]
 .lg.o[`monitor;"received process update from discovery service for process of type "," " sv string procs,:()];
 .servers.retry[];
 subscribe each (exec w from .servers.SERVERS) except subscribedhandles;
 }
