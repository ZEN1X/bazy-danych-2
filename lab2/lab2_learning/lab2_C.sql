use AdventureWorks2019;
go;

--- Skrypt Lab02.08
CREATE TABLE SalesOrderTotalsMonthly
(
    CustomerID int   NOT NULL,
    OrderMonth int   NOT NULL,
    SubTotal   money NOT NULL
)
GO

INSERT SalesOrderTotalsMonthly
SELECT CustomerID, DATEPART(m, OrderDate), SubTotal
FROM Sales.SalesOrderHeader
WHERE CustomerID IN (11000, 11001, 11004, 11006)
GO

SELECT *
FROM SalesOrderTotalsMonthly
         PIVOT (SUM(SubTotal) FOR OrderMonth IN
        ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])) AS a

--- Skrypt Lab02.09
CREATE TABLE SalesOrderTotalsYearly
(
    CustomerID int   NOT NULL,
    OrderYear  int   NOT NULL,
    SubTotal   money NOT NULL
)
GO

INSERT SalesOrderTotalsYearly
SELECT CustomerID, YEAR(OrderDate), SubTotal
FROM Sales.SalesOrderHeader
WHERE CustomerID IN (SELECT DISTINCT(CustomerID)
                     FROM Sales.SalesOrderHeader);
GO

select distinct OrderYear from SalesOrderTotalsYearly

SELECT *
FROM SalesOrderTotalsYearly
         PIVOT (SUM(SubTotal) FOR OrderYear IN ([2011], [2012], [2013], [2014])) AS a
GO

DROP TABLE SalesOrderTotalsYearly
DROP TABLE SalesOrderTotalsMonthly
