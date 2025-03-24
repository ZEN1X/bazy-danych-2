use AdventureWorks2019;
go

-- Zadanie 1
/*
 Opracować przykład procedury składowanej z wykorzystaniem kursora
 tworzący wydruk z dowolnej tabeli w bazie danych AdventureWorks w
 określonym formacie.
 */

if object_id('dbo.usp_GetPersonInfo') is not null
    drop procedure dbo.usp_GetPersonInfo;
go

create procedure dbo.usp_GetPersonInfo as
    set nocount on;
begin
    -- deklaracje zmiennych
    declare @ID int;
    declare @FirstName name;
    declare @LastName name;
    declare @Phone phone;
    declare @Email nvarchar(50);

    -- kursor
    declare PersonCursor cursor fast_forward for select top 8 p.BusinessEntityID,
                                                              FirstName,
                                                              LastName,
                                                              PhoneNumber,
                                                              EmailAddress
                                                 from Person.Person                p
                                                          join Person.PersonPhone  pp on p.BusinessEntityID = pp.BusinessEntityID
                                                          join Person.EmailAddress ea on p.BusinessEntityID = ea.BusinessEntityID
                                                 where pp.PhoneNumberTypeID = 1
                                                 order by LastName, FirstName;

    -- otwarcie kursora i wczytanie pierwszego wiersza
    open PersonCursor;
    fetch next from PersonCursor into @ID, @FirstName, @LastName, @Phone, @Email;

    -- pętla wczytująca kolejne wiersze
    while @@fetch_status = 0 begin
        print concat('ID: ', @ID, ' Name: ', @FirstName, ' ', @LastName);
        print concat('- Phone: ', @Phone);
        print concat('- Email: ', @Email);

        fetch next from PersonCursor into @ID, @FirstName, @LastName, @Phone, @Email;
    end

    -- zwolnienie zasobów
    close PersonCursor;
    deallocate PersonCursor;
end
go

-- Wykonanie procedury
exec dbo.usp_GetPersonInfo;
go