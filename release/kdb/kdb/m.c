#include "k.h"
#define _LARGEFILE64_SOURCE 1
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/mman.h>
#define SE krr(strerror(errno))
#define TE krr("type")
typedef struct h3 {I b,c,t;} H3;
typedef struct h4 {I b,r;H t,u;} H4;
ZH t[] = {0,KI,KF,KC};
K1(m) {
  struct stat s;H3 h;I n=sizeof(h);
  P(xt!=-KS,TE)I fd=open(xs,O_RDONLY|O_LARGEFILE); 
  P(fd==-1,SE)P(-1==fstat(fd,&s),SE)P(n>s.st_size,TE);
  P(n!=read(fd,&h,n),SE)P(h.t<-3||h.t>-1,TE);
  H4*p=mmap(NULL,s.st_size-(h.t==-3),PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_NORESERVE,fd,0);
  P(!p,SE)p->b=8447;p->r=0;p->t=t[-h.t];p->u=0;close(fd);R (K)&p->r;
}
/*
% k
  `x 1:1 2  
  `y 1:1 2.0
  `z 1:"ab"
% q
q)m:`:./m 2:(`m;1)
q)m`x.l
1 2
q)m`y.l
1 2f
q)m`z.l
"ab"
*/
