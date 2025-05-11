use [testCLR];
go

insert into test1
    (data)
values
    (N'Hello world'),
    (N'Goodbye :)');
go

select *
from test1_log;
go
