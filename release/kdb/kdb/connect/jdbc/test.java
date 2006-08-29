// k db -p 2001
import java.sql.*;
public class test{public static void main(String args[]){
 try{Class.forName("k.jdbc");  //loads the driver 
  Connection c = DriverManager.getConnection("jdbc:kx://localhost:2001");
  Statement e = c.createStatement();
  e.execute("create table t(i int,f float,s varchar,d date,t time,z timestamp,b varbinary)");
  PreparedStatement p = c.prepareStatement("insert into t values(?,?,?,?,?,?,?)");
  p.setInt(1,2);p.setDouble(2,2.3);p.setString(3,"asd");
  p.setDate(4,Date.valueOf("2000-01-01"));
  p.setTime(5,Time.valueOf("12:34:56"));p.setTimestamp(6,Timestamp.valueOf("2000-01-01 12:34:56"));
  byte[]b=new byte[2];b[0]=0x61;b[1]=0x62;p.setBytes(7,b);
  p.execute();
  ResultSet r = e.executeQuery("select * from t");
  ResultSetMetaData m= r.getMetaData();int n=m.getColumnCount();
  for(int i=0;i<n;)System.out.println(m.getColumnName(++i));
  while(r.next())for(int i=0;i<n;)System.out.println(r.getObject(++i));
  c.close();}catch(Exception e){System.out.println(e.getMessage());}}}