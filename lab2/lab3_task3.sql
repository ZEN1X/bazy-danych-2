use AdventureWorks2019;

-- Zadanie 3
-- a) CASE do zapytania nr 2

-- Przygotowujemy tymczasową tabelę.
create table #SalesOrderTotalsYearly
(
    CustomerID int   not null,
    OrderYear  int   not null,
    SubTotal   money not null
);

insert #SalesOrderTotalsYearly
select CustomerID, year(OrderDate), SubTotal
from Sales.SalesOrderHeader
where CustomerID in (select distinct (CustomerID)
                     from Sales.SalesOrderHeader);

-- PIVOT przy wykorzystaniu CASE
select CustomerID,
       sum(case when OrderYear = 2011 then SubTotal end) as [2011],
       sum(case when OrderYear = 2012 then SubTotal end) as [2012],
       sum(case when OrderYear = 2013 then SubTotal end) as [2013],
       sum(case when OrderYear = 2014 then SubTotal end) as [2014]
from #SalesOrderTotalsYearly
group by CustomerID
order by CustomerID;

-- b)
use tempdb;

create table Measurements
(
    Hour         tinyint       not null check (Hour >= 0 and Hour <= 23),
    Minute       tinyint       not null check (Minute >= 0 and Minute <= 59),
    CO2Val       decimal(6, 2) not null,
    VehicleCount int
);

insert into Measurements
values (0, 5, 10.15, 3),
       (0, 15, 12.20, 5),
       (0, 45, 11.90, 10),
       (1, 10, 15.00, 8),
       (1, 33, 16.50, 12),
       (2, 0, 18.30, 20),
       (2, 30, 19.10, 25),
       (3, 5, 25.70, 40),
       (3, 20, 28.55, 45);

-- CO2 min, max, sum
select 'CO2 MIN',
       *
from (select CO2Val, Hour
      from Measurements) as SRC
         pivot ( min(CO2Val) for Hour in ([0], [1], [2], [3])) as PivotTable
union all
select 'CO2 MAX',
       *
from (select CO2Val, Hour
      from Measurements) as SRC
         pivot ( max(CO2Val) for Hour in ([0], [1], [2], [3])) as PivotTable
union all
select 'CO2 SUM',
       *
from (select CO2Val, Hour
      from Measurements) as SRC
         pivot ( sum(CO2Val) for Hour in ([0], [1], [2], [3])) as PivotTable
union all
-- Vehicles min, max, sum
select 'Vehicles MIN',
       *
from (select VehicleCount, Hour
      from Measurements) as SRC
         pivot ( min(VehicleCount) for Hour in ([0], [1], [2], [3])) as PivotTable
union all
select 'Vehicles MAX',
       *
from (select VehicleCount, Hour
      from Measurements) as SRC
         pivot ( max(VehicleCount) for Hour in ([0], [1], [2], [3])) as PivotTable
union all
select 'Vehicles SUM',
       *
from (select VehicleCount, Hour
      from Measurements) as SRC
         pivot ( sum(VehicleCount) for Hour in ([0], [1], [2], [3])) as PivotTable;
