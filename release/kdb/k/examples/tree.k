d:0 1 2 2 1 1  /depth
v:!#d   /value

/ tree from depth;value
tdv:{[d;v](1#v),(c _ d-1)_f'(c:&1=d)_ v}

/ depth from tree
dt:{0,/1+_f'1_ x}

/ value from tree
vt:{(1#x),/_f'1_ x}

t:tdv[d;v]
dt t
vt t

/ these 3 recursions stop when they run out of data



 