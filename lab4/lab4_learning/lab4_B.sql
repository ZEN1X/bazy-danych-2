use AdventureWorks2019;
go

if object_id('dbo.usp_GetCustOrders') is not null
    drop proc dbo.usp_GetCustOrders;
go

-- Initial procedure
create proc dbo.usp_GetCustOrders @custid as   nchar(5),
                                  @fromdate as datetime = '19000101',
                                  @todate as   datetime = '99991231' as
    set nocount on;
select SalesOrderID, CustomerID, SalesPersonID, OrderDate
from Sales.SalesOrderHeader
where CustomerID = @custid
  and OrderDate >= @fromdate
  and OrderDate < @todate;
go

-- Test examples:
exec dbo.usp_GetCustOrders N'30052';

exec dbo.usp_GetCustOrders N'30052', DEFAULT, '20111201';

exec dbo.usp_GetCustOrders N'30052', '20110801', '20111201';

-- Output parameter version
alter proc dbo.usp_GetCustOrders @custid as   nchar(5),
                                 @fromdate as datetime = '19000101',
                                 @todate as   datetime = '99991231',
                                 @numrows as  int output as
    set nocount on;
declare @err as int;
select SalesOrderID, CustomerID, SalesPersonID, OrderDate
from Sales.SalesOrderHeader
where CustomerID = @custid
  and OrderDate >= @fromdate
  and OrderDate < @todate;
select @numrows = @@rowcount, @err = @@error;
    return @err;
go

-- Output test
declare @myerr as int, @mynumrows as int;

exec @myerr = dbo.usp_GetCustOrders @custid = N'30052', @fromdate = '20110801', @todate = '20111102',
              @numrows = @mynumrows output;

select @myerr as err, @mynumrows as rc;

-- Temporary table
if object_id('tempdb..#CustOrders') is not null
    drop table #CustOrders;
go

create table #CustOrders
(
    SalesOrderID  int      not null primary key,
    CustomerID    nchar(5) not null,
    SalesPersonID int      not null,
    OrderDate     datetime not null
);
go

declare @myerr as int, @mynumrows as int;

insert into #CustOrders(SalesOrderID, CustomerID, SalesPersonID, OrderDate) exec @myerr = dbo.usp_GetCustOrders
                                                                                          @custid = N'30052',
                                                                                          @fromdate = '20110801',
                                                                                          @todate = '20111102',
                                                                                          @numrows = @mynumrows output;

select *
from #CustOrders;

select @myerr as err, @mynumrows as rc;
