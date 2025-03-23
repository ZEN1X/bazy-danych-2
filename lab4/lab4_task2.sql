use AdventureWorks2019;
go

-- Zadanie 2
/*
 Opracować przykład wyzwalacza typu DML dla dowolnego obiektu (tabeli
 lub widoku) w bazie danych AdventureWorks.
 */

if object_id('Person.tr_PersonInsert') is not null
    drop trigger Person.tr_PersonInsert;
go

create trigger Person.tr_PersonInsert
    on Person.Person
    after insert as
begin
    set nocount on;

    declare @insertedPerson name;
    declare @ID int;
    declare @out nvarchar(128);

    declare PersonCursor cursor for select BusinessEntityID, FirstName + ' ' + LastName
                                    from inserted;

    open PersonCursor;
    fetch next from PersonCursor into @ID, @insertedPerson;

    while @@fetch_status = 0 begin
        set @out = concat('Inserted person: ', @insertedPerson, ' with ID: ', @ID);
        print @out;

        fetch next from PersonCursor into @ID, @insertedPerson;
    end;

    close PersonCursor;
    deallocate PersonCursor;
end;
go

-- Sprawdzenie wyzwalacza
insert into Person.BusinessEntity default
values;

insert into Person.Person(BusinessEntityID, PersonType, FirstName, LastName)
values
    (scope_identity(), 'IN', 'John', 'Doe');
go