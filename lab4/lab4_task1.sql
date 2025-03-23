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
    declare @out nvarchar(100);

    -- kursor
    declare PersonCursor cursor fast_forward for select top 8 BusinessEntityID, FirstName, LastName
                                                 from Person.Person
                                                 order by LastName, FirstName;

    -- otwarcie kursora i wczytanie pierwszego wiersza
    open PersonCursor;
    fetch next from PersonCursor into @ID, @FirstName, @LastName;

    -- pętla wczytująca kolejne wiersze
    while @@fetch_status = 0 begin
        set @out = concat('ID: ', @ID, ' Name: ', @FirstName, ' ', @LastName);
        print @out;

        fetch next from PersonCursor into @ID, @FirstName, @LastName;
    end

    -- zwolnienie zasobów
    close PersonCursor;
    deallocate PersonCursor;
end
go

-- Wykonanie procedury
exec dbo.usp_GetPersonInfo;
go