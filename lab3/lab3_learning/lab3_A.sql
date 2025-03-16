use AdventureWorks2019;
go;

set nocount on;

if object_id('dbo.fn_ConcatOrders') is not null
    drop function dbo.fn_ConcatOrders;
go

create function dbo.fn_ConcatOrders(@cid as nchar(5)) returns varchar(8000) as
begin
    declare @orders as varchar(8000);
    set @orders = '';

    select @orders = @orders + cast(SalesOrderID as varchar(10)) + ';'
    from Sales.SalesOrderHeader
    where CustomerID = @cid;

    return @orders;
end
go

select CustomerID, dbo.fn_ConcatOrders(CustomerID) as Orders
from Sales.SalesOrderHeader;

if object_id('dbo.fn_ConcatOrders') is not null
    drop function dbo.fn_ConcatOrders;