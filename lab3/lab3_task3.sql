use AdventureWorks2019;
go

-- Zadanie 3
/*
 Baza danych: AdventureWorks2019
 Temat: Funkcja UDF, która zwraca tabelę z danymi zamówień dla zadanego
 odbiorcy. Odbiorcę zadajemy przez jego nazwę.
 Tabele: Sales.Customer, Sales.SalesOrderHeader, Person.Person
 Kolumny: CustomerID, PersonID,BusinessEntityID
 */

if object_id('dbo.GetCustomerOrders') is not null
    drop function dbo.GetCustomerOrders;
go

create function dbo.GetCustomerOrders(@customer_name name)
    returns table as return select p.FirstName + ' ' + p.LastName as CustomerName,
                                   c.CustomerID,
                                   soh.SalesOrderID,
                                   soh.OrderDate,
                                   soh.DueDate,
                                   soh.ShipDate,
                                   soh.TotalDue
                            from AdventureWorks2019.Sales.Customer                  c
                                     join AdventureWorks2019.Sales.SalesOrderHeader soh on c.CustomerID = soh.CustomerID
                                     join AdventureWorks2019.Person.Person          p on c.PersonID = p.BusinessEntityID
                            where p.FirstName + ' ' + p.LastName = @customer_name;
go

select *
from dbo.GetCustomerOrders('Kim Abercrombie');
go