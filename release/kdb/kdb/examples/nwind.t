load'/program files/microsoft office/office/samples/northwind.mdb'
('ShipVia','Shippers')fkey'Orders'

/ Query 1: Alphabetical List of Products
/   MS SQL
/      SELECT DISTINCTROW Products.*, Categories.CategoryName 
/      FROM Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
/      WHERE (((Products.Discontinued)=No))
/      Question:  What does DISTINCTROW do for you in this query, or any of the ones in here?

/   SQL
$create view SQL1 as
      select Products.ProductID, Products.ProductName, Products.SupplierID, Products.CategoryID,
      Products.QuantityPerUnit, Products.UnitPrice, Products.UnitsInStock, Products.UnitsOnOrder,
      Products.ReorderLevel, Products.Discontinued,
      Categories.CategoryName 
      from Products,Categories
      where Products.CategoryID = Categories.CategoryID
      and not Products.Discontinued
      
/   KSQL
KSQL1: select ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,
      UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued,
      CategoryID.CategoryName from Products where not Discontinued

/ Query 11: Product Sales for 1997
/   There a difference in the data; the MS SQL computed column entries are "Qtr " followed by one of "1" throgh "4", while 
/   the corresponding entries in the KSQL table are "Q" followed by one of "1" through "4".  The SQL computed column 
/   agrees with the MS SQL column, although it could just have easily been defined to agree with the KSQL column.  
/   Also, even though the text of the computed column in the SQL and KSQL tables agree, the KSQL column is enumerated.

/   MS SQL
/      SELECT DISTINCTROW Categories.CategoryName, Products.ProductName, 
/      Sum(CCur([Order Details].[UnitPrice]*[Quantity]*(1-[Discount])/100)*100) AS ProductSales, 
/      "Qtr " & DatePart("q",[ShippedDate]) AS ShippedQuarter
/      FROM (Categories INNER JOIN Products ON [Categories].[CategoryID]=[Products].[CategoryID]) 
/      INNER JOIN (Orders INNER JOIN [Order Details] ON 
/      [Orders].[OrderID]=[Order Details].[OrderID]) ON 
/      [Products].[ProductID]=[Order Details].[ProductID]
/      WHERE ((([Orders].[ShippedDate]) Between #1/1/97# And #12/31/97#))
/      GROUP BY Categories.CategoryName, Products.ProductName, "Qtr " & DatePart("q",[ShippedDate]);

/   SQL

$alter table Orders add column ShippedMonth int default -1
$alter table Orders add column ShippedQuarter int default ''
$update Orders set ShippedMonth = extract(month from ShippedDate) 
$update Orders set ShippedQuarter = case
                                       when ShippedMonth between 1 and 3 then 'Qtr 1' 
                                       when ShippedMonth between 4 and 6 then 'Qtr 2' 
                                       when ShippedMonth between 7 and 9 then 'Qtr 3' 
                                       when ShippedMonth between 10 and 12 then 'Qtr 4' 
                                    end
$create view SQL11 as
      select Categories.CategoryName, Products.ProductName, Orders.ShippedQuarter,
      sum (OrderDetails.UnitPrice*OrderDetails.Quantity*(1-OrderDetails.Discount)/100)*100 as ProductSales
      from Categories, Products, OrderDetails, Orders
      where Categories.CategoryID=Products.CategoryID 
      and Products.ProductID=OrderDetails.ProductID
      and OrderDetails.OrderID=Orders.OrderID
      and Orders.ShippedDate between '1997-01-01' and '1997-12-31'
      group by Categories.CategoryName, Products.ProductName, Orders.ShippedQuarter

/   KSQL
KSQL11: select ProductSales: sum (UnitPrice*Quantity*(1-Discount)/100)*100
      by ProductID.CategoryID.CategoryName, ProductID.ProductName, ShippedQuarter: OrderID.ShippedDate.qtr
      from OrderDetails where OrderID.ShippedDate within ('1997-01-01','1997-12-31')

/ Note: The KSQL by statement, unlike the MS SQL group by statement, makes it clear that the
/   phrase ProductID.ProductName is redundant. 


/ Query 2: Category Sales for 1997 

/   MS SQL
/      SELECT DISTINCTROW [Product Sales for 1997].CategoryName, 
/      Sum([Product Sales for 1997].ProductSales) AS CategorySales
/      FROM [Product Sales for 1997]
/      GROUP BY [Product Sales for 1997].CategoryName;

/   SQL
$create view SQL2 as
      select CategoryName, sum ProductSales as CategorySales       
      from SQL11
      group by CategoryName

/   KSQL
KSQL2: select 
       CategorySales: sum ProductSales       
       by CategoryName
       from KSQL11 

/ Query 3: Current Product List 

/   MS SQL
/      SELECT [Product List].ProductID, [Product List].ProductName
/      FROM Products AS [Product List]
/      WHERE ((([Product List].Discontinued)=No))
/      ORDER BY [Product List].ProductName;

/   Note: "Product List" in the MS SQL query must be a mistake; if the purpose is to refer to
/   Query 1, then the WHERE clause in Query 3 is unnecessary.

/   SQL
$create view SQL3 as
      select ProductID, ProductName
      from Products
      where Discontinued=0
      order by ProductName

/   KSQL
KSQL3:'ProductName' asc select ProductID, ProductName from Products where not Discontinued  


/ Query 4: Customers and Suppliers by City

/   MS SQL
/      SELECT City, CompanyName, ContactName, "Customers" AS [Relationship] 
/      FROM Customers
/      UNION SELECT City, CompanyName, ContactName, "Suppliers"
/      FROM Suppliers
/      ORDER BY City, CompanyName;

/   SQL
$create view SQL4 as
      select City, CompanyName, ContactName, 'Customer'
      from Customers
      union
      select City, CompanyName, ContactName, 'Supplier'
      from Suppliers

$SQL4:select City, CompanyName, ContactName from SQL4 
     order by City, CompanyName

/   KSQL
KSQL4: 'City' asc 'CompanyName' asc 
       (select City,CompanyName,ContactName,'Customer' from Customers)
       union 
       (select City,CompanyName,ContactName,'Supplier' from Suppliers)

 
/ Query 9: Order Subtotals

/   MS SQL
/      SELECT DISTINCTROW [Order Details].OrderID, 
/      Sum(CCur([UnitPrice]*[Quantity]*(1-[Discount])/100)*100) AS Subtotal
/      FROM [Order Details]
/      GROUP BY [Order Details].OrderID;

/   SQL
$create view SQL9 as
      select OrderID, 
      sum (UnitPrice*Quantity*(1-Discount)/100)*100 as Subtotal
      from OrderDetails
      group by OrderID

/   KSQL
KSQL9: select Subtotal:sum (UnitPrice*Quantity*(1-Discount)/100)*100
      by OrderID from OrderDetails

/ Query 5: Employee Sales by Country

/   MS SQL
/      PARAMETERS [Beginning Date] DateTime, [Ending Date] DateTime;
/      SELECT DISTINCTROW Employees.Country, Employees.LastName, Employees.FirstName, 
/      Orders.ShippedDate, Orders.OrderID, [Order Subtotals].[Subtotal] AS SaleAmount
/      FROM Employees INNER JOIN 
/        (Orders INNER JOIN [Order Subtotals] ON [Orders].[OrderID]=[Order Subtotals].[OrderID]) 
/      ON [Employees].[EmployeeID]=[Orders].[EmployeeID]
/      WHERE ((([Orders].[ShippedDate]) Between [Beginning Date] And [Ending Date]));

/   SQL
$create view SQL5 as
      select Orders.OrderID,
      Employees.Country, Employees.LastName, Employees.FirstName, 
      Orders.ShippedDate, SQL9.Subtotal AS SaleAmount
      FROM Employees,Orders,SQL9 
      where Employees.EmployeeID=Orders.EmployeeID and Orders.OrderID=SQL9.OrderID 
      and Orders.ShippedDate between '1900-01-01' and '2000-01-01'

/   KSQL
KSQL5: select OrderID,
      EmployeeID.Country, EmployeeID.LastName, EmployeeID.FirstName, 
      ShippedDate, SaleAmount:KSQL9[OrderID].Subtotal from Orders
      where ShippedDate within ('1900-01-01','2000-01-01')      


/ Query 6: Invoices

/   MS SQL
/      SELECT DISTINCTROW Orders.ShipName, Orders.ShipAddress, Orders.ShipCity, Orders.ShipRegion, 
/      Orders.ShipPostalCode, Orders.ShipCountry, Orders.CustomerID, Customers.CompanyName, 
/      Customers.Address, Customers.City, Customers.Region, Customers.PostalCode, 
/      Customers.Country, [FirstName] & " " & [LastName] AS Salesperson, 
/      Orders.OrderID, Orders.OrderDate, Orders.RequiredDate, Orders.ShippedDate, 
/      Shippers.CompanyName, [Order Details].ProductID, Products.ProductName, 
/      [Order Details].UnitPrice, [Order Details].Quantity, [Order Details].Discount, 
/      CCur([Order Details].[UnitPrice]*[Quantity]*(1-[Discount])/100)*100 AS ExtendedPrice, 
/      Orders.Freight
/      FROM Shippers INNER JOIN (Products INNER JOIN ((Employees INNER JOIN 
/      (Customers INNER JOIN Orders ON [Customers].[CustomerID]=[Orders].[CustomerID]) 
/      ON [Employees].[EmployeeID]=[Orders].[EmployeeID]) INNER JOIN [Order Details] 
/      ON [Orders].[OrderID]=[Order Details].[OrderID]) 
/      ON [Products].[ProductID]=[Order Details].[ProductID]) 
/      ON [Shippers].[ShipperID]=[Orders].[ShipVia];

/   SQL
/     Note: I don't know how to create the computed column Salesperson.

/   KSQL

KSQL6: select OrderID.ShipName, OrderID.ShipAddress, OrderID.ShipCity, OrderID.ShipRegion, 
      OrderID.ShipPostalCode, OrderID.ShipCountry, OrderID.CustomerID, 
      OrderID.CustomerID.CompanyName, 
      OrderID.CustomerID.Address, OrderID.CustomerID.City, OrderID.CustomerID.Region, 
      OrderID.CustomerID.PostalCode, OrderID.CustomerID.Country, 
      Salesperson: OrderID.EmployeeID.FirstName+' '+OrderID.EmployeeID.LastName,
      OrderID, OrderID.OrderDate, OrderID.RequiredDate, OrderID.ShippedDate, 
      OrderID.ShipVia, ProductID, ProductID.ProductName, 
      UnitPrice, Quantity, Discount, 
      ExtendedPrice: (UnitPrice*Quantity*(1-Discount)/100)*100, 
      OrderID.Freight
      from OrderDetails 

/ Query 7: Invoices Filter

/   MS SQL
/      SELECT DISTINCTROW Invoices.*
/      FROM Invoices
/      WHERE ((([Invoices].[OrderID])=[Forms]![Orders]![OrderID]));

/   SQL
/     Note: kx SQL doesn't have Invoices.* and there's nothing new to be learned here by listing all the columns.
 
/   KSQL
KSQL7: select from KSQL6
      where OrderID=10248


/ Query 8: Order Details Extended

/   MS SQL
/      SELECT DISTINCTROW [Order Details].OrderID, [Order Details].ProductID, Products.ProductName, 
/      [Order Details].UnitPrice, [Order Details].Quantity, [Order Details].Discount, 
/      CCur([Order Details].[UnitPrice]*[Quantity]*(1-[Discount])/100)*100 AS ExtendedPrice
/      FROM Products INNER JOIN [Order Details] ON 
/      [Products].[ProductID]=[Order Details].[ProductID]
/      ORDER BY [Order Details].[OrderID];

/   SQL
$create view SQL8 as
      select OrderDetails.OrderID, OrderDetails.ProductID, Products.ProductName, 
      OrderDetails.UnitPrice, OrderDetails.Quantity, OrderDetails.Discount, 
      (OrderDetails.UnitPrice*OrderDetails.Quantity*(1-OrderDetails.Discount)/100)*100 as ExtendedPrice
      from Products,OrderDetails 
      where Products.ProductID=OrderDetails.ProductID
      order by OrderDetails.OrderID

/   KSQL
KSQL8: 'OrderID' asc select OrderID, ProductID, ProductID.ProductName, UnitPrice, Quantity, Discount,
      ExtendedPrice: (UnitPrice*Quantity*(1-Discount)/100)*100
      from OrderDetails


/ Query 10: Orders Qry

/   MS SQL
/      SELECT DISTINCTROW Orders.OrderID, Orders.CustomerID, Orders.EmployeeID, Orders.OrderDate, 
/      Orders.RequiredDate, Orders.ShippedDate, Orders.ShipVia, Orders.Freight, Orders.ShipName, 
/      Orders.ShipAddress, Orders.ShipCity, Orders.ShipRegion, Orders.ShipPostalCode, 
/      Orders.ShipCountry, Customers.CompanyName, Customers.Address, Customers.City, 
/      Customers.Region, Customers.PostalCode, Customers.Country
/      FROM Customers INNER JOIN Orders ON [Customers].[CustomerID]=[Orders].[CustomerID];

/   SQL
$create view SQL10 as
      select Orders.OrderID, Orders.CustomerID, Orders.EmployeeID, Orders.OrderDate, 
      Orders.RequiredDate, Orders.ShippedDate, Orders.ShipVia, Orders.Freight, Orders.ShipName, 
      Orders.ShipAddress, Orders.ShipCity, Orders.ShipRegion, Orders.ShipPostalCode, 
      Orders.ShipCountry, Customers.CompanyName, Customers.Address, Customers.City, 
      Customers.Region, Customers.PostalCode, Customers.Country
      from Customers, Orders 
      where Customers.CustomerID=Orders.CustomerID

/   KSQL
KSQL10: select OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, 
       ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry, 
       CustomerID.CompanyName, CustomerID.Address, CustomerID.City, CustomerID.Region, 
       CustomerID.PostalCode, CustomerID.Country
       from Orders


/ Query 12: Products Above Average Price

/   MS SQL
/      SELECT DISTINCTROW Products.ProductName, Products.UnitPrice
/      FROM Products
/      WHERE (((Products.UnitPrice)>(SELECT AVG([UnitPrice]) From Products)))
/      ORDER BY [Products].[UnitPrice] DESC;

/   SQL
$create view SQL12 as
      select ProductName, UnitPrice
      from Products
      where Products.UnitPrice>(select avg(UnitPrice) from Products)
      order by UnitPrice desc

/     Note:
/      where UnitPrice>avg(UnitPrice)
/     works too

/   KSQL
KSQL12: 'UnitPrice' desc select ProductName, UnitPrice from Products
       where UnitPrice>avg UnitPrice
        

/ Query 13: Products by Category

/   MS SQL
/      SELECT DISTINCTROW Categories.CategoryName, Products.ProductName, Products.QuantityPerUnit, 
/      Products.UnitsInStock, Products.Discontinued
/      FROM Categories INNER JOIN Products ON [Categories].[CategoryID]=[Products].[CategoryID]
/      WHERE ((([Products].[Discontinued])<>Yes))
/      ORDER BY [Categories].[CategoryName], [Products].[ProductName];

/   SQL
$create view SQL13 as
      select Categories.CategoryName, Products.ProductName, Products.QuantityPerUnit, 
      Products.UnitsInStock, Products.Discontinued
      from Categories, Products 
      where Categories.CategoryID=Products.CategoryID
      and Products.Discontinued
      order by Categories.CategoryName, Products.ProductName

/   KSQL
KSQL13: 'CategoryName' asc 'ProductName' asc select CategoryID.CategoryName, ProductName, 
       QuantityPerUnit, UnitsInStock, Discontinued
       from Products where Discontinued


/ Query 14: Quarterly Orders

/   MS SQL
/      SELECT DISTINCTROW Customers.CustomerID, Customers.CompanyName, Customers.City, 
/      Customers.Country
/      FROM Customers RIGHT JOIN Orders ON [Customers].[CustomerID]=[Orders].[CustomerID]
/      WHERE ((([Orders].[OrderDate]) Between #1/1/97# And #12/31/97#));

/   SQL
$create view SQL14 as 
      select Customers.CustomerID, Customers.CompanyName, Customers.City, 
      Customers.Country
      from Customers, Orders where Customers.CustomerID=Orders.CustomerID
      and Orders.OrderDate between '1997-01-01' and '1997-12-31'

/ KSQL
KSQL14: select CustomerID, CustomerID.CompanyName, CustomerID.City, 
        CustomerID.Country 
        from Orders where OrderDate within ('1997-01-01','1997-12-31')  
  

/ Query 15: Quarterly Orders by Product

/   MS SQL
/      TRANSFORM Sum(CCur([Order Details].[UnitPrice]*[Quantity]*(1-[Discount])/100)*100) 
/      AS ProductAmount
/      SELECT Products.ProductName, Orders.CustomerID, Year([OrderDate]) AS OrderYear
/      FROM Products INNER JOIN (Orders INNER JOIN [Order Details] 
/      ON Orders.OrderID = [Order Details].OrderID) 
/      ON Products.ProductID = [Order Details].ProductID
/      WHERE (((Orders.OrderDate) Between #1/1/97# And #12/31/97#))
/      GROUP BY Products.ProductName, Orders.CustomerID, Year([OrderDate])
/      PIVOT "Qtr " & DatePart("q",[OrderDate],1,0) In ("Qtr 1","Qtr 2","Qtr 3","Qtr 4");

/   SQL
/     Note: TRANSFORM - PIVOT have no sql equivalents      

/   KSQL
KSQL15: select ProductAmount:sum 100*UnitPrice*Quantity*(1-Discount)/100
      by ProductID.ProductName, OrderID.CustomerID.CompanyName, OrderID.OrderDate.quarter
      from OrderDetails
      where OrderID.OrderDate.year=1997

/ Query 16: Sales by Category

/   MS SQL
/      SELECT DISTINCTROW Categories.CategoryID, Categories.CategoryName, Products.ProductName, 
/      Sum(OrderDetails Extended].[ExtendedPrice]) AS ProductSales
/      FROM Categories INNER JOIN (Products INNER JOIN (Orders INNER JOIN [Order Details Extended] 
/      ON [Orders].[OrderID]=[Order Details Extended].[OrderID]) 
/      ON [Products].[ProductID]=[Order Details Extended].[ProductID]) 
/      ON [Categories].[CategoryID]=[Products].[CategoryID]
/      WHERE ((([Orders].[OrderDate]) Between #1/1/97# And #12/31/97#))
/      GROUP BY Categories.CategoryID, Categories.CategoryName, Products.ProductName
/      ORDER BY [Products].[ProductName];

/   SQL
$create view SQL16 as
      select Categories.CategoryID, Categories.CategoryName, Products.ProductName, 
      Sum(SQL8.ExtendedPrice) as ProductSales
      from Categories, Products, Orders, SQL8 
      where Orders.OrderID=SQL8.OrderID 
      and Products.ProductID=SQL8.ProductID 
      and Categories.CategoryID=Products.CategoryID
      and Orders.OrderDate between '1997-01-01' and '1997-12-31'
      group by Categories.CategoryID, Categories.CategoryName, Products.ProductName
      order by Products.ProductName

/     Note: "group by" fails if Categories.CategoryID is included (in which case the 
/     "max" in "max Categories.CategoryID" must be removed). 

/   KSQL
KSQL16: 'ProductName' asc select ProductSales: sum ExtendedPrice
      by ProductID.CategoryID, ProductID.CategoryID.CategoryName, ProductName 
      from KSQL8
      where OrderID.OrderDate within ('1997-01-01','1997-12-31') 

/     Note: the data in the SQL16 and KSQL16 results match, but the columns are in 
/     different order.


/ Query 17: Sales by Year

/   MS SQL
/      PARAMETERS Forms![Sales by Year Dialog]!BeginningDate DateTime, 
/      Forms![Sales by Year Dialog]!EndingDate DateTime;
/      SELECT DISTINCTROW Orders.ShippedDate, Orders.OrderID, [Order Subtotals].Subtotal, 
/      Format([ShippedDate],"yyyy") AS [Year]
/      FROM Orders INNER JOIN [Order Subtotals] ON [Orders].[OrderID]=[Order Subtotals].[OrderID]
/      WHERE ((([Orders].[ShippedDate]) Is Not Null And 
/      ([Orders].[ShippedDate]) Between [Forms]![Sales by Year Dialog]![BeginningDate] 
/      And [Forms]![Sales by Year Dialog]![EndingDate]));

/   SQL
$create view SQL17 as
      select Orders.ShippedDate, Orders.OrderID, SQL9.Subtotal, 
      extract(year from Orders.ShippedDate) as year
      from Orders, SQL9
      where Orders.OrderID=SQL9.OrderID
      and (Orders.ShippedDate is not null) 
      and Orders.ShippedDate between '1900-01-01' and '2000-01-01'

/   KSQL
KSQL17: select ShippedDate, OrderID, KSQL9[OrderID].Subtotal, 
      ShippedDate.year
      from Orders
      where ShippedDate within ('1900-01-01','2000-01-01')

      
/ Query 18: Ten Most Expensive Products

/   MS SQL
/      SELECT DISTINCTROW TOP 10 [Products].[ProductName] AS TenMostExpensiveProducts, 
/      Products.UnitPrice
/      FROM Products
/      ORDER BY [Products].[UnitPrice] DESC;

$create view SQL18 as 
 select ProductName,UnitPrice from Products order by UnitPrice desc rowcount 10
 
/   KSQL
KSQL18:10 first desc select ProductName,UnitPrice from Products

\


TODO
* Query 4	table union table order by ...
* Query 7	select t.* ...
