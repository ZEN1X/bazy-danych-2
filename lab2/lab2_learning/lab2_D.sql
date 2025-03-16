use AdventureWorks2019;

--- Skrypt Lab02.11
WITH SalesCTE(ProductID, SalesOrderID)
         AS
         (SELECT ProductID, COUNT(SalesOrderID)
          FROM Sales.SalesOrderDetail
          GROUP BY ProductID)
SELECT *
FROM SalesCTE;
-- All Products and the number of times that they were ordered

--- Skrypt Lab02.12
WITH SalesCTE(ProductID, SalesOrderID)
         AS
         (SELECT ProductID, COUNT(SalesOrderID)
          FROM Sales.SalesOrderDetail
          GROUP BY ProductID)
SELECT *
FROM SalesCTE
WHERE SalesOrderID > 200;
-- All Products that were ordered more than 200 times

--- Skrypt Lab02.13
WITH SalesCTE(ProductID, SalesOrderID)
         AS
         (SELECT ProductID, COUNT(SalesOrderID)
          FROM Sales.SalesOrderDetail
          GROUP BY ProductID)
SELECT AVG(SalesOrderID)
FROM SalesCTE
WHERE SalesOrderID > 50;
-- Average number of times a Product was ordered
-- for all Products that appeared on an order
-- more than 50 times

--- Skrypt Lab02.14
select OrganizationNode,
       OrganizationNode.ToString() as Node,
       OrganizationLevel,
       p.BusinessEntityID,
       Firstname,
       Lastname,
       JobTitle
from Person.person p
         join HumanResources.Employee e
              on p.BusinessEntityID = e.BusinessEntityID;

--- Skrypt Lab02.15
WITH EmployeeManager AS
         (SELECT Firstname + ' ' + Lastname as Employee,
                 Firstname + ' ' + Lastname as Manager,
                 0                          as EmployeeLevel,
                 CAST('/' AS hierarchyid)   as OrgNode
          FROM HumanResources.Employee e
                   JOIN Person.Person p
                        ON p.BusinessEntityID = e.BusinessEntityID
          WHERE e.OrganizationLevel is null
          UNION ALL
          SELECT p.Firstname + ' ' + p.Lastname as Employee,
                 man.Employee                   as Manager,
                 man.EmployeeLevel + 1          as EmployeeLevel,
                 OrganizationNode               as OrgNode
          FROM HumanResources.Employee e
                   JOIN Person.Person p
                        ON p.BusinessEntityID = e.BusinessEntityID,
               EmployeeManager man
          WHERE OrganizationNode.GetAncestor(1) = man.OrgNode)
SELECT Employee, Manager
FROM EmployeeManager;