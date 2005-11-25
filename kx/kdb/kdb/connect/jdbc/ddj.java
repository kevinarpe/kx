// k ddj.s  cf., dr.dobb's journal jan/98
import java.sql.*;
public class ddj{
public static void main(String args[]){
 try{k.c.t();Class.forName("k.jdbc");  //loads the driver
  Connection c=DriverManager.getConnection("jdbc:kx://localhost:2001");
System.out.println("connect");k.c.t();
  PreparedStatement s=c.prepareStatement("select * from t where i<? and x<?");
  s.setInt(1,10000);s.setDouble(2,10000.0);ResultSet r=s.executeQuery();while(r.next());
System.out.println("select");k.c.t();
  PreparedStatement u0=c.prepareStatement("update t set x=? where i=?");
  Statement u1=c.createStatement();
  for(int i=0;i++<100;){u0.setDouble(1,2000.0);u0.setInt(2,5);u0.executeUpdate();
   u1.executeUpdate("insert into t values(5,'name',10,2000.0,'password',date'1997-08-29')");}
System.out.println("update");k.c.t();
  CallableStatement p=c.prepareCall("{call p[?,?]}");
  for(int i=0;i++<100;){p.setDouble(1,2000.0);p.setInt(2,5);p.execute();}
System.out.println("call");k.c.t();
  c.close();}catch(Exception e){System.out.println(e.getMessage());}}}

/* 
Dr. Dobb's JDBC(jan/98) page 82. (typeIV 100%java)
kdb/jdbc compared with sybase/jdbc. (dynamic queries)
[jdbc has 8 interfaces and 284 public methods.]

		kdb		sybase
jdbc-compliant	YES		NO 
driver size	20KB		700KB
download(56.6)	5 seconds	200 seconds
connect		.1 seconds	1.1 seconds

[kdb times are on 450MHZ;sybase on 200MHZ]
select 10000	.3 seconds	100 seconds
upsert 10000*	.4 seconds  	500 seconds
update/insert	.03 seconds	.05 seconds
procedure call	.02 seconds 	.05 seconds

* jdbc doesn't support upsert.
*/