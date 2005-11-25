/ extended meta information for Kdb databases
/ $Id: meta.k,v 1.8 2002/06/02 18:24:18 S.Garland Exp $

createMeta:{ / create databases containing extended meta information
	t:(.d.tables"")_dvl `TMP`METADB`METATC`METAT`EMPTYTABLE
	// METATC (table columns)
	.d.r"METATC:([tableName:varchar(),name:varchar()])"
	i:0
	do[#t
		sti:$ti:t i
		.d.r"TMP:meta '",sti,"'"
		.d.r"update enum:1,tableName:'",sti,"' from 'TMP'"
		/ is indexed
		.d.r"TMP.i:TMP.name in index ",sti
		/ type (basic or enumerated)
		TMP[`t]:ti[~(!ti);`T]
		TMP[`t;&_n~'TMP[`t]]:`
		/ is sorted
		TMP[`sa]:1~'tiS:ti[~(!ti);`S] / asc
		TMP[`sd]:2~'tiS / desc
		/ is a key
		TMP[`k]:1~'ti[~(!ti);`K]
		.d.r"'METATC' insert1 TMP"
		i+:1]
	.d.r"delete TMP"
	.d.r"update enum:0,t:T from 'METATC' where t=''"
	.d.r"METATC:'tableName'asc'name'asc select tableName,name,t,T,enum,k,sa,sd,s:sa or sd,i,D,N,W,P from METATC"
	// METAT (tables)
	.d.r"METAT:distinct select tableName from METATC"
	.d.r"METAT:'tableName' key METAT"
	.d.r"update i:0,k:0,s:0,ski:0,sk:0,si:0,ki:0,SP:0,PT:0,hasEnum:0,isEnumTarget:0 from 'METAT'"
	.d.r("update PT:1 from 'METAT' where tableName in ?";,.d.PT) / is partitioned
	.d.r"update SP:isSplayed each tableName from 'METAT'" / is SPlayed, ie rsave'd
	.d.r"'METAT' insert select nc:count$ by tableName from 'METATC'" / number of columns
	.d.r"'METAT' insert select i:1,tableName from METATC where i" / is indexed
	.d.r"'METAT' insert select k:1,tableName from METATC where k" / is keyed
	.d.r"'METAT' insert select s:1,tableName from METATC where s" / is sorted
	.d.r"'METAT' insert select ski:1,tableName from METATC where s,k,i" / has sorted+indexed key(s)
	.d.r"'METAT' insert select sk:1,tableName from METATC where s,k" / has sorted key(s)
	.d.r"'METAT' insert select si:1,tableName from METATC where s,i" / has sorted and indexed column(s)
	.d.r"'METAT' insert select ki:1,tableName from METATC where k,i" / has indexed key(s)
	.d.r"'METAT' insert select hasEnum:1,tableName from METATC where not t=T" / has enumerated column(s)
	.d.r"update isEnumTarget:1 from 'METAT' where tableName in select t from METATC where not t=T"
	/ count the number of records
    .d.r"update nr:countPT each tableName from 'METAT' where PT"
    .d.r"update nr:count each tableName from 'METAT' where not PT"
	.d.r"METAT:'tableName' asc METAT"
	/ and now enumerate to allow more interesting reports
	.d.r"METATC.tableName:METAT METATC.tableName"
	.d.r"METATC.enumTarget:METAT METATC.t"
	// METADB (database)
	.d.r("METADB:([dbName:current_database]ts:current_timestamp,host:?,p:?,P:?,S:?,kdb:?,k:?,nt:count METAT,nc:count METATC)";(_h;_p;.d.P;.d.S;.d.vers;_k))
	}

saveMeta:{ / save the META* tables right into the current_database, convenient for browsing with show, or the kdb browser interface
	.d.r"current_database save 'METADB'"
	.d.r"current_database save 'METAT'"
	.d.r"current_database save 'METATC'"}

saveMetaXml:{ / save the META* databases in xml format, so they can be easily diff'd with something like cvs
	`METADB.xml 0:.h.XD METADB
	`METAT.xml 0:.h.XD METAT
	`METATC.xml 0:.h.XD METATC}

saveMetaCsv:{ / save the META* databases in csv format, so they can be easily diff'd with something like cvs
	.d.r"save 'METADB.csv'"
	.d.r"save 'METAT.csv'"
	.d.r"save 'METATC.csv'"}
	
countPT:{.d.r". select count$ from ",($x)}

isSplayed:{7=*4::'x[]}
