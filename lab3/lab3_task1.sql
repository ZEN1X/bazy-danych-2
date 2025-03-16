use AdventureWorks2019;
go

-- Zadanie 1
/*
 Baza danych: AdventureWorks2019
 Temat: Funkcja UDF, która zwraca nchar z danymi określonymi przez
 BusinessEntityID. Każda z kolumn zwracanych jest oddzielona od pozostałych
 średnikiem.
 Dane: nazwisko, imię, email, adres.
 Tabele: Person.Person, Person.EmailAddress, Person.BussinessEntity,
 Person.BussinessEntityAddress, Person.Address.
 Kolumny: PersonID, BusinessEntityID.
 */

if object_id('dbo.GetBusinessEntityInfo') is not null
    drop function dbo.GetBusinessEntityInfo;
go

create function dbo.GetBusinessEntityInfo(@bid int) returns nchar(256) as
begin
    declare @info_str nchar(256);

    select @info_str =
           p.LastName + ';' + p.FirstName + ';' + coalesce(ea.EmailAddress, '') + ';' + coalesce(a.AddressLine1, '') +
           '' + coalesce(a.AddressLine2, '') + ', ' + coalesce(a.PostalCode, '') + ' ' + coalesce(a.City, '')
    from AdventureWorks2019.Person.Person                              p
             left join AdventureWorks2019.Person.EmailAddress          ea on p.BusinessEntityID = ea.BusinessEntityID
             left join AdventureWorks2019.Person.BusinessEntityAddress bea on p.BusinessEntityID = bea.BusinessEntityID
             left join AdventureWorks2019.Person.Address               a on bea.AddressID = a.AddressID
    where p.BusinessEntityID = @bid;

    return @info_str;
end;
go

-- Przykład użycia
select AdventureWorks2019.dbo.GetBusinessEntityInfo(33);
go