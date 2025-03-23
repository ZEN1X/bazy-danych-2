use tempdb;
go

if object_id('dbo.usp_Proc1') is not null
    drop proc dbo.usp_Proc1;
if object_id('dbo.usp_Proc2') is not null
    drop proc dbo.usp_Proc2;
if object_id('dbo.T1') is not null
    drop table dbo.T1;
go

-- Will fail on execution, table does not exist
create proc dbo.usp_Proc1 as
select col1
from dbo.T1;
go

exec dbo.usp_Proc1;

-- Now create table and test again
create table dbo.T1
(
    col1 int
);

insert into dbo.T1(col1)
values
    (1);

exec dbo.usp_Proc1;

-- Will fail to compile, column does not exist
create proc dbo.usp_Proc2 as
select col2
from dbo.T1;
go

-- Cleanup
if object_id('dbo.usp_Proc1') is not null
    drop proc dbo.usp_Proc1;
if object_id('dbo.usp_Proc2') is not null
    drop proc dbo.usp_Proc2;
if object_id('dbo.T1') is not null
    drop table dbo.T1;
