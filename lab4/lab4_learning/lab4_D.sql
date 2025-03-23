use AdventureWorks2019;
go

if object_id('dbo.usp_GetOrders') is not null
    drop proc dbo.usp_GetOrders;
go

create proc dbo.usp_GetOrders @odate as datetime as
select SalesOrderID, CustomerID, SalesPersonID, OrderDate
from Sales.SalesOrderHeader
where OrderDate >= @odate;
go

-- Enable query stats
set statistics io on;

-- Test and view execution plan
exec dbo.usp_GetOrders '20111110';
