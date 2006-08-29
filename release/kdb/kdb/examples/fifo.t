/ Cost of goods sold

/ solve for single item
price:(1,2,3,4)
qty:  (2,3,4,5)
sold:8
sum price*0 deltas sold min sums qty

/ solve for table of items
item:(
 [item:(1,2)]
  sold:(8,6))

buy:([]
 item: (1,1,1,1,2,2,2),
 qty:  (2,3,4,5,3,4,5),
 price:(1,2,3,4,2,3,4))

select sum price*0 deltas item.sold min sums qty by item from buy

/ (long or short)

/ transactions(instrument,qty,price)
t:([]
 i:(1,1,1,1,2,2,2),
 q:(10,5,-7,-4,-2,5,-4),
 p:(1,2,3,4,5,6,7))

/ buys
b:select -sum q by i from t where q>0

/ sells
s:select -sum q by i from t where q<0

/ trim(long and short)
update q1:0 deltas s[i].q min sums q by i from't'where q>0
update q1:0 deltas b[i].q max sums q by i from't'where q<0

/ realized p&l
select sum q1*p by i from t
