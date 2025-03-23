use AdventureWorks2019;
go

if object_id('dbo.usp_GetSortedPersons') is not null
    drop proc dbo.usp_GetSortedPersons;
go

create proc dbo.usp_GetSortedPersons @colname as sysname = null as
declare @msg as nvarchar(500); if @colname is null
    begin
        set @msg = N'A value must be supplied for parameter @colname.';
        raiserror (@msg, 16, 1);
        return;
    end if @colname not in (N'BusinessEntityID', N'LastName', N'PhoneNumber')
    begin
        set @msg = N'Valid values for @colname are: N''BusinessEntityID'', N''LastName'', N''PhoneNumber''.';
        raiserror (@msg, 16, 1);
        return;
    end if @colname = N'BusinessEntityID'
    select p.BusinessEntityID, LastName, PhoneNumber
    from Person.Person               p
             join Person.PersonPhone a on a.BusinessEntityID = p.BusinessEntityID
    order by p.BusinessEntityID;
else
    if @colname = N'LastName'
        select p.BusinessEntityID, LastName, PhoneNumber
        from Person.Person               p
                 join Person.PersonPhone a on a.BusinessEntityID = p.BusinessEntityID
        order by LastName;
    else
        if @colname = N'PhoneNumber'
            select p.BusinessEntityID, LastName, PhoneNumber
            from Person.Person               p
                     join Person.PersonPhone a on a.BusinessEntityID = p.BusinessEntityID
            order by PhoneNumber;
go

-- Test:
exec dbo.usp_GetSortedPersons @colname = N'LastName';

-- Permissions
-- deny select on Person.Person to user1;
--
-- grant execute on dbo.usp_GetSortedPersons to user1;
