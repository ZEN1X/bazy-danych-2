use tempdb;
go

if object_id('dbo.T1') is not null
    drop table dbo.T1;
go

create table dbo.T1
(
    keycol  int         not null
        constraint PK_T1 primary key check (keycol > 0),
    datacol varchar(10) not null
);
go

if object_id('dbo.fn_T1_getkey') is not null
    drop function dbo.fn_T1_getkey;
go

create function dbo.fn_T1_getkey() returns int as
begin
    return case when not exists ( select *
                                  from dbo.T1
                                  where keycol = 1 ) then 1
                else ( select min(keycol + 1)
                       from dbo.T1 as A
                       where not exists ( select *
                                          from dbo.T1 as B
                                          where B.keycol = A.keycol + 1 ) ) end;
end
go

alter table dbo.T1
    add default (dbo.fn_T1_getkey()) for keycol;
go

-- Test the function:
insert into dbo.T1(datacol)
values
    ('a');

insert into dbo.T1(datacol)
values
    ('b');

insert into dbo.T1(datacol)
values
    ('c');

delete
from dbo.T1
where keycol = 2;

insert into dbo.T1(datacol)
values
    ('d');

select *
from dbo.T1;
go
