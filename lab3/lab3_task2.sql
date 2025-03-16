use AdventureWorks2019;
go

-- Zadanie 2
/*
 Baza danych: AdventureWorks2019
 Temat: Funkcja UDF, która zwraca zestaw rekordów: nazwisko, imię, email, adres,
 uporządkowanych nazwisko, imię, adres. Z pełnego zestawu funkcja zwraca
 podzbiór określony przez numer rekordu w zakresie ustalonym przez argumenty
 funkcji.
 */

if object_id('dbo.GetBusinessEntityInfoSubset') is not null
    drop function dbo.GetBusinessEntityInfoSubset;
go

create function dbo.GetBusinessEntityInfoSubset(@begin int, @end int)
    returns table as return select p.LastName,
                                   p.FirstName,
                                   coalesce(ea.EmailAddress, '')                           as email,
                                   coalesce(a.AddressLine1, '') + '' + coalesce(a.AddressLine2, '') + ', ' +
                                   coalesce(a.PostalCode, '') + ' ' + coalesce(a.City, '') as address
                            from AdventureWorks2019.Person.Person                              p
                                     left join AdventureWorks2019.Person.EmailAddress          ea
                                               on p.BusinessEntityID = ea.BusinessEntityID
                                     left join AdventureWorks2019.Person.BusinessEntityAddress bea
                                               on p.BusinessEntityID = bea.BusinessEntityID
                                     left join AdventureWorks2019.Person.Address               a on bea.AddressID = a.AddressID
                            order by LastName, FirstName, address
                            offset @begin - 1 rows fetch next (@end - @begin + 1) rows only;
go

-- Przykład użycia
select *
from dbo.GetBusinessEntityInfoSubset (1, 25);