use AdventureWorks2019;
go;

-- 1
SELECT MONTH(OrderDate), TerritoryID, CustomerID, SUM(TotalDue)
FROM Sales.SalesOrderHeader
WHERE SalesPersonID = 277
  AND YEAR(OrderDate) = 2011
GROUP BY MONTH(OrderDate), TerritoryID, CustomerID
UNION ALL
SELECT MONTH(OrderDate), TerritoryID, NULL, SUM(TotalDue)
FROM Sales.SalesOrderHeader
WHERE SalesPersonID = 277
  AND YEAR(OrderDate) = 2011
GROUP BY MONTH(OrderDate), TerritoryID
UNION ALL
SELECT MONTH(OrderDate), NULL, CustomerID, SUM(TotalDue)
FROM Sales.SalesOrderHeader
WHERE SalesPersonID = 277
  AND YEAR(OrderDate) = 2011
GROUP BY MONTH(OrderDate), CustomerID
UNION ALL
SELECT NULL, NULL, NULL, SUM(TotalDue)
FROM Sales.SalesOrderHeader
WHERE SalesPersonID = 277
  AND YEAR(OrderDate) = 2011

-- 2, grouping sets
SELECT MONTH(OrderDate), TerritoryID, CustomerID, SUM(TotalDue)
FROM Sales.SalesOrderHeader
WHERE SalesPersonID = 277
  AND YEAR(OrderDate) = 2011
GROUP BY GROUPING SETS ( (MONTH(OrderDate), TerritoryID, CustomerID),
                         (MONTH(OrderDate), TerritoryID),
                         (MONTH(OrderDate), CustomerID), () );