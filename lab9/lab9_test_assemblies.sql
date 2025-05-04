use lab9;
go

-- Zadanie 1
declare @t_complex table
                   (
                       z dbo.complexnumber
                   );

insert into @t_complex
values
    ('3+4i'),
    ('-1+2i'),
    (null);

select z.ToString() as number, z.Modulus() as modulus, z.Conjugate().ToString() as conjugate
from @t_complex;
go

-- Zadanie 2
declare @t table
           (
               v int
           );

insert into @t(v)
values
    (0),
    (1),
    (3),
    (6),
    (7),
    (9),
    (-3), -- nie jest liczba naturalna
    (12);

select dbo.CountDivBy3(v) as divisibleBy3Count
from @t;
go

-- Zadanie 3
set statistics time on;

declare @nums table
              (
                  x float
              );

with CTE(n) as ( select 1 union all select n + 1 from CTE where n < 10000 )
insert
into @nums(x)
select rand(checksum(newid())) * 100
from CTE
option (maxrecursion 0);

-- bult-in
select avg(x), var(x), stdev(x)
from @nums;

-- custom
select dbo.UdaAvg(x), dbo.UdaVar(x), dbo.UdaStdev(x)
from @nums;

set statistics time off;