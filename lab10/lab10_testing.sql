use [testCLR];
go

-- Zadanie 1
insert into test1
    (data)
values
    (N'Hello world'),
    (N'Goodbye :)');
go

select *
from test1_log;
go

-- Zadanie 2
exec sp_InsertAandB @a_data = 'alpha', @b_data = 'beta';
go

select *
from dbo.a;

select *
from dbo.b;

select *
from dbo.a_b;
go
