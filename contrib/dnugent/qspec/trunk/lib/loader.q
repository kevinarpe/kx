\d .tst

loadTests:{[paths]; interpretTest each findTests[paths]}

interpretTest:{[path] .utl.require path}

findTests:{[paths];
 raze suffixMatch[;".q"] each distinct (),paths
 }

suffixMatch:{[path;suffix];
 if[path like "*",suffix;:enlist path];
 f: ` sv' path,'f where not (f:(),key path) like ".*";
 d: f where 11h = (type key@) each f;
 f: f where f like "*",suffix;
 raze f, .z.s[;suffix] each d
 }