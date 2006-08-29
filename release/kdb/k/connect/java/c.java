//javac k/c.java   c(host,port) r=k(s,x,y,z) ka(s,a) ksa(s,a) util(p(print) t(type) n(count))  jdk1.3 ibm? sun?
//2003.02.20 readFully
//2002.08.24 ServerSocket&w(2,Object)
//2002.03.27 read dictionaries(5)
package k;import java.io.*;import java.net.*;import java.util.*; // javac k/c.java
public class c{private static long t;public static void t(){long u=t;t=System.currentTimeMillis();if(u>0)p(t-u);}
public static void p(boolean x){System.out.println(x);}public static void p(long x){System.out.println(x);}
public static void p(int x){System.out.println(x);}public static void p(Object x){System.out.println(x);}
public static int t(Object x){return x instanceof Integer?1:x instanceof Double?2:x instanceof Byte?3:x instanceof String?4:
 x instanceof int[]?-1:x instanceof double[]?-2:x instanceof byte[]?-3:x instanceof String[]?-4:x instanceof Object[]?0:
 x instanceof Boolean?8:x instanceof java.sql.Timestamp?11:x instanceof java.sql.Time?10:x instanceof Date?9:6;}
public static int n(Object x){int t=t(x);return t==4?((String)x).length():t==-1?((int[])x).length:t==-2?((double[])x).length:t==-3?((byte[])x).length:((Object[])x).length;}

// b(bytes) r(read) w(write) a(arch)
private void q(String s)throws Exception{throw new Exception(s);}private int r8(int j){return j+(7&-j);}
private int b(Object x){int i=0,n,t=t(x),j=8;if(t>0)return t==4?5+n(x):t==2||t==10|t==11?16:8;n=n(x);
  if(t==-4)for(;i<n;)j+=1+n(((String[])x)[i++]);else if(t==0)for(;i<n;)j+=r8(b(((Object[])x)[i++]));else j+=t==-1?n*4:t==-2?n*8:n+1;return j;}
private boolean a;private byte[]b,b8=new byte[8];private int j;private Socket h;
private int ri(){int i=(b[a?j:j+3]&255)+((b[a?j+1:j+2]&255)<<8)+((b[a?j+2:j+1]&255)<<16)+(b[a?j+3:j]<<24);j+=4;return i;}
private double rf(){long i=ri(),j=ri();return Double.longBitsToDouble(((long)(a?j:i)<<32)+(0xffffffffL&(a?i:j)));}
private String rs(){int k=j;for(;b[k]!=0;)++k;char[]s=new char[k-j];for(int i=0;j<k;)s[i++]=(char)(0xFF&b[j++]);++j;return new String(s);}
private Object r()throws Exception{int i=0,n,t=ri();if(t==1)return new Integer(ri());
 if(t==2){j+=4;return new Double(rf());}
 if(t==3)return new Byte(b[j++]);if(t==4)return rs();if(t==6){if(0<b[j])q(rs());return null;}		n=ri();
 if(t==-1){int[]x=new int[n];for(;i<n;)x[i++]=ri();return x;}		 
 if(t==-2){double[]x=new double[n];for(;i<n;)x[i++]=rf();return x;}	
 if(t==-3){byte[]x=new byte[n];for(;i<n;)x[i++]=b[j++];++j;return x;}if(t==-4){String[]x=new String[n];for(;i<n;++i)x[i]=rs();return x;}
 if(t!=0&&t!=5)q("type");Object[]x=new Object[n];for(;i<n;j=r8(j))x[i++]=r();return x;}
private void w(int i){b[j]=(byte)(i>>24);b[j+1]=(byte)(i>>16);b[j+2]=(byte)(i>>8);b[j+3]=(byte)i;j+=4;}
private void w(double f){long i=Double.doubleToLongBits(f);w((int)(i>>32));w((int)i);}
private void w(String s){int i=0,n=n(s);for(;i<n;)b[j++]=(byte)s.charAt(i++);b[j++]=0;}
private void w(Object x){int i=0,n,t=t(x);w(t<8?t:t<10?1:2);if(t==1){w(((Integer)x).intValue());return;}
 if(t==2){w(0);w(((Double)x).doubleValue());return;}if(t==3){b[j++]=((Byte)x).byteValue();return;}
 if(t==4){w((String)x);return;}if(t==6){w(0);return;}if(t==8){w(((Boolean)x).booleanValue()?1:0);return;}
 if(t>8){double f=((Date)x).getTime()/8.64e7;if(t==9)w((int)f-23741);else{w(0);w(f<1?f:f-23741);}return;}	w(n=n(x));
 if(t==-1){for(;i<n;)w(((int[])x)[i++]);return;}				if(t==-2){for(;i<n;)w(((double[])x)[i++]);return;}
 if(t==-3){for(;i<n;)b[j++]=((byte[])x)[i++];b[j++]=0;return;}	if(t==-4){for(;i<n;)w(((String[])x)[i++]);return;}
 for(;i<n;j=r8(j))w(((Object[])x)[i++]);}
public void w(int i,Object x)throws Exception{int n=b(x);b=new byte[8+n];b[3]=(byte)i;j=4;w(n);w(x);h.getOutputStream().write(b);}
private Object sa(String s,Object x){Object[]a={s.getBytes(),x};return x==null?a[0]:a;}
public synchronized void ksa(String s,Object[]a)throws Exception{w(0,sa(s,a));}
public void ks(String s)throws Exception{ksa(s,null);}
public void ks(String s,Object x)throws Exception{Object[]a={x};ksa(s,a);}
public void ks(String s,Object x,Object y)throws Exception{Object[]a={x,y};ksa(s,a);}
public synchronized Object k()throws Exception{DataInputStream i=new DataInputStream(h.getInputStream());
 i.readFully(b=b8);a=b[0]==1;j=4;int n=ri();i.readFully(b=new byte[n]);j=0;return r();}
public synchronized Object ka(String s,Object[]a)throws Exception{w(1,sa(s,a));return k();}
public Object k(String s)throws Exception{return ka(s,null);}
public Object k(String s,Object x)throws Exception{Object[]a={x};return ka(s,a);}
public Object k(String s,Object x,Object y)throws Exception{Object[]a={x,y};return ka(s,a);}
public Object k(String s,Object x,Object y,Object z)throws Exception{Object[]a={x,y,z};return ka(s,a);}
public Object k(String s,Object x,Object y,Object z,Object w)throws Exception{Object[]a={x,y,z,w};return ka(s,a);} //sparc jdk1.2.2 hack
public c(ServerSocket s)throws Exception{h=s.accept();h.getInputStream().read(b8);} //h.setTcpNoDelay(true);} //Double.longBitsToDouble(0L);}
public c(String m,int p)throws Exception{h=new Socket(m,p);h.getOutputStream().write(b8);}public c()throws Exception{this("",2001);}
public void close(){if(h!=null)try{h.close();}catch(IOException e){}finally{h=null;}}
public static void main(String args[]){
 try{
//c c=new c(new ServerSocket(2001));while(true)c.w(2,c.k());
 c c=new c();Object[]r=(Object[])c.k("{(x;y;z)}",new Integer(2),new Double(2.3),new String("qwert"));for(int i=0;i<n(r);)p(r[i++]);
  }catch(Exception e){p("Exception: "+e.getMessage());}}}

//450MHZ/NT 1300 roundtrips; 8MB(IF)or 60K(read S)/sec
// rs: .9 String(b,j,n)2 String(b,j,n,8859_l)6   jvm eventually closes the sockets
