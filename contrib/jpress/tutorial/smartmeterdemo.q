/- Load the tutorial functions
@[system;"l tutorial.q";{-1"Failed to load tutorial.q : ",x;exit 1}]

/- load the smart meter functions
@[system;"l smartmeterfunctions.q";{-1"Failed to load tutorial.q : ",x;exit 1}]

/- Load the HDB
hdbdir:$[0=count .z.x;"./hdb";.z.x 0]
@[system;"l ",hdbdir;{-1"Failed to load specified hdb ",x,": ",y;exit 1}[hdbdir]]

/- turn on garbage collection
.tut.gcON[]

/- Add in the smart meter details
.tut.add["meterusage[2013.08.01;2013.08.10]";"Total meter usage for every customer over a 10 day period"];
.tut.add["monthlyusage[2013.08m]";"Total meter usage for every customer for a given month"];
.tut.add["monthlyusagebycusttype[2013.08 2013.09m]";"Total monthly usage by customer type for a given set of months"];
.tut.add["meterusagepivot[2013.08.01;2013.08.31;0b]";"Total meter usage pivotted by customer type and region"];
.tut.add["meterusagepivot[2013.08.01;2013.08.31;1b]";"Total meter usage pivotted by customer type and region as a %"];
.tut.add["dailystats[2013.08.01;2013.08.10]";"Daily statistics for each meter including flow rates to the customer"];
.tut.add["groupusage[2013.08.01;2013.08.31;exec meterid from static where custtype=`com;15]";"Time bucketed usage stats for a set of meterids aggregated together"];
.tut.add["dailyaverageprofile[2013.08.01;2013.08.31;exec meterid from static where custtype=`com;15]";"Time bucketed usage, averaged over a date range, for a set of meter ids"];
.tut.add["comparetoprofile[2013.08.01;2013.08.31;exec meterid from static where custtype=`com;15;2013.08.01;2013.08.31;exec meterid from static where custtype=`ind]";"Compare average daily volume profiles e.g. for different time periods, different customer types etc."]


/- Print out the tutorial info
.tut.db[];
-1"The meter table contains the updates from the smart meters.";
-1"The usage value is the total cumulative usage to date.";
-1"The time is the time the update was received.";
-1"The static table contains the associated lookup data for each meter.";
-1"Each meter belongs to a specific customer type in a specific region.";

.tut.info["SMART METER DEMO"]
