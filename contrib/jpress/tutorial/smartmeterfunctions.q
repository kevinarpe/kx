/- Functions to analyze the smartmeter data
/- we have two tables
/- meter contains the output of each meter
/- The output of each meter is the total usage to date, 
/- rather than the usage since the last update 
/- static contains associated static data

/- ---------------------
/- TOTAL USAGE analytics
/- ---------------------

/- Work out the usage of each customer in a given time frame
/- e.g. meterusage[2013.08.10;2013.08.29]
meterusage:{[startdate; enddate]
 
 /- calculate the usage at the start and the end
 start:select first usage by meterid from meter where date=startdate;
 end:select last usage by meterid from meter where date=enddate;
 
 /- subtract the two
 end-start}

/- calculate the meter usage for a given month
/- add in the month field
/- e.g. monthlyusage[2013.08m]
monthlyusage:{[month] 
 `month`meterid xkey 
  select month:month,meterid,usage 
  from meterusage[`date$month; -1+`date$month+1]}

/- total monthly usage by customer type
/- operate over a list of months
/- e.g. monthlyusagebycusttype[2013.08 2013.09m]
monthlyusagebycusttype:{[months] 
 select sum usage by month,custtype 
 from 
  (raze monthlyusage each months,:()) 
  lj 
  `meterid xkey select meterid,custtype from static}

/- Generate a pivot table with the % usage of each customer type in each region
/- http://code.kx.com/wiki/Pivot
meterusagepivot:{[startdate;enddate;aspercent]
 t:meterusage[startdate;enddate];
 
 /- join on the static data
 t:t lj static;
 
 /- Calculate the total usage for each grouping
 t:select sum usage by custtype,region from t;
 
 /- Convert to % values
 if[aspercent;t:update usage:100*usage%sum usage from t];
 
 /- pivot the data to have the regions as row ids
 /- and the customer types as the column headers
 C:asc exec distinct custtype from t;
 t1:exec C#custtype!usage by region:region from t;
 
 /- fill the pivot table with 0s
 0^t1}
/--------------------------
/- TIME PROFILING analytics
/--------------------------

/- Build a usage profile for a given set of meterids
/- The meterids can then be used to profile a customer type, region etc.
/- The usage profile is bucketed into discrete time buckets
/- The appropriate size will depend on the sample period of the data that was built
/- The default sampling is 15 minutes
/- e.g. groupusage[2013.08.01; 2013.08.31; 100000 100001; 15]
groupusage:{[startdate; enddate; meterids; timebucket]
 /- To get the usage of a group of ids, we can just calculate a sum 
 /- of all the usage statistics within the bucket 
 /- then compare with the previous bucket
 /- use ` as a wildcard to calculate across all customers
 t:$[meterids~`;
	select first usage 
	by date,(timebucket*0D00:01) xbar time
 	from meter where date within (startdate;enddate);
  	select sum usage 
   	by date,(timebucket*0D00:01) xbar time 
   	from meter where date within (startdate;enddate),meterid in meterids]; 

 /- The usage within each bucket is then the difference between the current
 /- bucket and the next bucket
 t:update usage:deltas usage from t;
 
 t}

/- Use groupusage to generate a daily average profile
/- i.e. over a given set of days,
/- calculate the average usage within each time period
/- e.g. dailyaverageprofile[2013.08.01; 2013.08.31; 100000 100001; 15]
dailyaverageprofile:{[startdate;enddate;meterids;timebucket]
 
 /- get the usage stats for the group
 t:groupusage[startdate;enddate;meterids;timebucket];
 
 /- For the profile we then calculate the average and peak 
 /- of the time buckets across the days
 select avgusage:avg usage
 by time:`timespan$timebucket xbar time.minute
 from t}

/- compare a profile for a set of ids
/- to a specific date for a (possibly different) set of ids
comparetoprofile:{[startdate;enddate;meterids;timebucket;comparestartdate;compareenddate;compareids]
 update difference:avgusage - compareusage 
 from 
  dailyaverageprofile[startdate;enddate;meterids;timebucket]  
  lj
  `time xkey 
   select time,compareusage:avgusage 
   from dailyaverageprofile[comparestartdate;compareenddate;compareids;timebucket]}

customertypeprofiles:{[startdate;enddate;timebucket]
 /- Calculate the total usage in each bucket
 t:select sum usage
   by date,custtype:(exec meterid!custtype from static)[meterid], (timebucket*0D00:01) xbar time
   from meter where date within (startdate;enddate);
 
 /- Calculate the usage by getting the diff with the next usage
 t:update deltas usage
   by custtype 
   from t;
 
 /- Calculate the average across the days
 /- reduce the time to a timespan 
 t:select avg usage
   by custtype, `timespan$time
   from t;

 /- Pivot the table
 C:asc exec distinct custtype from t;
 exec C#custtype!usage by time:`timestamp$2000.01.01+time from t}

/----------------------------------
/- CUSTOMER TYPE / REGION analytics
/----------------------------------

/- daily analysis for each customer
/- e.g. dailystats[2013.08.01;2013.08.10]
dailystats:{[startdate;enddate]
 /- use the inner select to only calculate the usage in each time bucket only once
 select date,meterid,usage, peakrate:max each allrates, 
        minrate:min each allrates, avgrate:avg each allrates 
 from 
  select usage:(last usage) - first usage, allrates:1 _ deltas usage 
  by date,meterid 
  from meter 
  where date within (startdate;enddate)}

/---------
/- BILLING
/---------



/-----------
/- Utilities
/-----------

/- Get the meter ids for a (set of) customertypes or regions
custids:{exec meterid from static where custtype in x}
regionids:{exec meterid from static where region in x}
