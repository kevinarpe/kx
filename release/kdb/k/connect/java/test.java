// k -i 2001
public class test{
public static void main(String args[]){
 try{k.c c=new k.c("localhost",2001);	// connect
  int[]i={2,3,4};			// client data
  System.out.println(c.k("+/",i));	// call analytic
  System.out.println(c.k("+",new Integer(2),new Double(2.3)));
  c.close();}
 catch(Exception e){System.out.println(e.getMessage());}}}
 