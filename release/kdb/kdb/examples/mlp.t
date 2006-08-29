/
sybase 25 minutes
kdb 4 seconds(sql or ksql)

profit and loss queries on 20,000,000 records.
(6-way join. result is 1,000,000 records)

sybase-sql
select count(*)from trades t, security_factor sf, security s
where 1=1
 and t.portfolio in (select portfolio_child from portfolio where portfolio_parent in (1108,1343,1110))
 and t.trade_date >= '1/17/1999' and t.trade_type != 35 and t.trade_status = 1
 and s.security = t.security and s.currency in (select currency from currency)
 and t.security = sf.security and sf.valid = 1
 and t.trade_type not in (select trade_type from trade_type where group_code = 6)
\

/ 200 records
currency:([currency:asc 200]) #currency_code:(varchar),description:(varchar),extel:(varchar),invert:(int))

/ 6000 records
security:([security:asc 6000] currency:6000 rand 200)
/price_symbol:(varchar),cusip_isn:(varchar),description:(varchar), security_type:(int), country:(int), currency:(int),exchange:(int),
/broker_symbol:(varchar),description2:(varchar),portia_exchange:(int),portia_security:(int),bloomberg:(varchar),reuters:(varchar))

/ 6000 records
security_factor:([security:asc 6000] factor:6000 rand 9,valid:1) #date:(timestamp)

/ 40 records
trade_type:([trade_type:asc 40] group_code:40 rand 7) #description:(varchar), group_name:(varchar))

/ 1200 records
portfolio:([portfolio:asc 1200] portfolio parent:1200 rand 50) #hierarchy_id:(int))

n:2000000 # records
trade:([trade:asc n] portfolio portfolio:n rand 1200,security:n rand 6000,
 trade_status:1,trade_type:n rand 40,trade_date:date['1999-01-01']+asc n rand 365)
/quantity:(float),executing:(int),custodian:(int),give_up_broker:(int),trade_date:(timestamp),settle_date:(timestamp),
/repo_collateral:(int),system_id:(int),system_value:(varchar),trade_price:(float),trade_yield:(float),fx_to_usd:(float),
/version_id:(int),mlp_id:(int),strategy:(int),curr1:(int),curr2:(int),update_time:(timestamp),broker_portfolo:(int))

'portfolio'index'trade'

/ ansi-sql
$:select count(*)from trade t, security s, security_factor sf
 where t.portfolio in (select portfolio from portfolio where parent in (1,5,9))
   and t.trade_date >= '1999-01-17' and t.trade_type <> 35 and t.trade_status = 1
   and t.trade_type not in (select trade_type from trade_type where group_code = 6)
   and t.security = s.security and s.currency in (select currency from currency)
   and t.security = sf.security and sf.valid = 1
  
/ ksql
:select count$from trade where portfolio.parent in (1,5,9),
  trade_date >= '1999-01-17', trade_type <> 35, trade_status = 1, trade_type.group_code <> 6, 
  security.currency in currency.currency, security_factor[security].valid
