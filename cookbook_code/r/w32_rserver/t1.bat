mkdir w32
gcc -I. -I"\Progra~1\R\R-2.15.0"/include -L. -lR  -shared -Wl,--export-all-symbols -Wl,--enable-auto-import -o w32/rserver.dll base.c q.a
