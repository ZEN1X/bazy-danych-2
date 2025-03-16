use tempdb;
go

if object_id('dbo.Employees') is not null
    drop table dbo.Employees;
go

create table dbo.Employees
(
    empid   int         not null primary key,
    mgrid   int         null references dbo.Employees,
    empname varchar(25) not null,
    salary  money       not null
);
go

insert into dbo.Employees(empid, mgrid, empname, salary)
values
    (1, null, 'David', 10000.00),
    (2, 1, 'Eitan', 7000.00),
    (3, 1, 'Ina', 7500.00),
    (4, 2, 'Seraph', 5000.00),
    (5, 2, 'Jiru', 5500.00),
    (6, 2, 'Steve', 4500.00),
    (7, 3, 'Aaron', 5000.00),
    (8, 5, 'Lilach', 3500.00),
    (9, 7, 'Rita', 3000.00),
    (10, 5, 'Sean', 3000.00),
    (11, 7, 'Gabriel', 3000.00),
    (12, 9, 'Emilia', 2000.00),
    (13, 9, 'Michael', 2000.00),
    (14, 9, 'Didi', 1500.00);
go

create unique index idx_unc_mgrid_empid on dbo.Employees (mgrid, empid);
go

if object_id('dbo.fn_subordinates') is not null
    drop function dbo.fn_subordinates;
go

create function dbo.fn_subordinates(@mgrid as int)
    returns @Subs table
                  (
                      empid   int         not null primary key nonclustered,
                      mgrid   int         null,
                      empname varchar(25) not null,
                      salary  money       not null,
                      lvl     int         not null,
                      unique clustered (lvl, empid)
                  ) as
begin
    declare @lvl as int;
    set @lvl = 0;

    insert into @Subs(empid, mgrid, empname, salary, lvl)
    select empid, mgrid, empname, salary, @lvl
    from dbo.Employees
    where empid = @mgrid;

    while @@rowcount > 0 begin
        set @lvl = @lvl + 1;
        insert into @Subs(empid, mgrid, empname, salary, lvl)
        select C.empid, C.mgrid, C.empname, C.salary, @lvl
        from @Subs                  as P
                 join dbo.Employees as C on p.lvl = @lvl - 1 and C.mgrid = p.empid;
    end
    return;
end
go

-- Test the function:
select empid, mgrid, empname, salary, lvl
from dbo.fn_subordinates(3) as S;
go

use tempdb;
go

if object_id('dbo.Employees') is not null
    drop table dbo.Employees;
go

if object_id('dbo.fn_subordinates') is not null
    drop function dbo.fn_subordinates;