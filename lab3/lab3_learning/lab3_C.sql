set nocount on;

use AdventureWorks2019;
go

if object_id('dbo.fn_GetCustOrders') is not null
    drop function dbo.fn_GetCustOrders;
go

create function dbo.fn_GetCustOrders(@cid as nchar(5))
    returns table as return select SalesOrderID, CustomerID, SalesPersonID, OrderDate, Duedate, ShipDate, Freight
                            from sales.salesorderheader
                            where CustomerID = @cid;
go

-- Test the function:
select O.SalesOrderID, O.CustomerID, OD.ProductID, OD.OrderQty
from dbo.fn_GetCustOrders('29533')    as O
         join sales.salesorderdetail as OD on O.SalesOrderID = OD.SalesOrderID;
go
